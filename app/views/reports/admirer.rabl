
node do
   {"total" => @report.total}
end
node do
   {"tags" => @report.tags.sort_by(&:count).reverse.map{|f| {name: f.name, y: (100*f.count/@report.total), count: f.count} }}
end
