


#Forbes World's Highest-Paid Actors 2015
first_name <- c('Robert','Jackie','Vin','Bradley','Adam')
last_name <- c('Downey','Chan','Diesel','Cooper','Sandler')

#tbody
step1 = paste(first_name, last_name, sep ="</td><td>")
step1
step2 = paste0("<tr><td>",step1,"</td></tr>")
step2
step3 = paste0(step2,collapse="\n")
step3
step4 = paste0("<tbody>",step3,"</tbody>")
step4
#thead
s1 = "<thead><tr><th>First Name</th><th>Second Name</th></tr></thead>"
html_all = paste("<table>",s1,step4, "</table>",sep="\n")
cat(html_all)


