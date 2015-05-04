
node do
   {"total" => @report.tags.collect{|f| f.to_a[1] }.reduce(:+)}
end
node do
   {"tags" => @report.tags.sort_by(&:y).reverse.map{|f| f.to_h }}
end
