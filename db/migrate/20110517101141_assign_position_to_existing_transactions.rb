class AssignPositionToExistingTransactions < ActiveRecord::Migration
  def self.up 
    datasets = []

    # all Transactions without a Position for each Asset
    Asset.all.each do |asset|
      datasets << Transaction.where(:asset_id => asset.id)
                             .where(:position_id => nil)
                             .order("date ASC")      
    end

    # extract data for each Asset
    datasets.each do |dataset|
      unless dataset.empty? 
        a = Asset.find(dataset.first.asset_id)

        # extract groups for each Position
        num = 0
        groups = [[]]
        dataset.each do |trans|
          groups.last << trans 

          if trans.type == "Purchase"
            num += trans.units
          else
            num -= trans.units
          end

          if num == 0
            groups << Array.new
          end
        end              

        # process each Position group
        groups.each do |group|
          p = a.positions.build
          p.save

          puts "Position #{p.id} for Asset #{a.name}"
          group.each do |t|
            puts t
            t.position = p
            t.save
          end
        end
      end
    end
  end

  def self.down
  end
end
