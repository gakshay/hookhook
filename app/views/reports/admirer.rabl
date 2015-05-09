
node do
   {"total" => @report.total}
end
if @report.total > 0
    node do
       {"tags" => @report.tags.sort_by(&:count).reverse }
    end
end