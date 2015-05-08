
node do
   {"total" => @report.total}
end
if @report.total > 0
    node do
       {"tags" => @report.tags.sort_by(&:count).reverse.map{|f| {name: f.name, y: (100*f.count/@report.total), count: f.count} }}
    end
end