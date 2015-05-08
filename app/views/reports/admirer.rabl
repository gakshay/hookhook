
node do
   {"total" => @report.total}
end
node do
   {"tags" => @report.tags.sort_by(&:count).reverse.map{|f| {name: f.name, y: (f.count/@report.total*100), count: f.count} }}
end
