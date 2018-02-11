#SSI: 5.24.2017 "Wrangle"

rows <- paste("<tr><td>", first_name, "</td><td>", last_name, "</td></tr>",sep = "",collapse = "/n")
tbody <- paste("<tbody>",rows,"</tbody>",sep="/n")

#vectorized paste to create portion, tack on tbody on the ends

# first argument is the string, second argument is the starting place, and the third argument is the ending place
substr("Robert",1,3) # should be "Rob"

# each argument can be a vector
substr(c("Robert","Bobby","Bob"),c(1,4,1),c(3,5,2)) # should be "Rob", "by", and "Bo"

# vector arguments will be recycled
substr(c("Robert","Bobby","Bob"),c(1,4),5) #should be "Rober", "by", "Bob"
# notice that there are less than 5 characters in "Bob" so it just went to the very end.

#if the starting place is larger than the string, will output "" (empty characters)
substr(c("Robert","Bobby","Bob"),4,5)

substr("Toyota-Camry",1,6) #toyota
substr("Toyota-Camry",8,12) #camry

x <- "Smith, John"
strsplit(x,", ")
# [[1]]
# [1] "Smith" "John" #take out comma and space
x[2] <- 'Lee, Henry'
y <- strsplit(x,", ")
y
# [[1]]
# [1] "Smith" "John"
# [[2]]
# [1] "Lee" "Henry" #splits into two different parts of list, each element into first v. last


# why is this useful???
# you may want to make a first name vector and last name vector
# heres how to do it - for example of context only...
#sapply is a way to loop - for every member y, run this function 
  #return the second element
y<- strsplit(x,", ")
y

firstName <- sapply(X = y, FUN = function(x){
  return(x[2])
})
lastName <- sapply(X = y, FUN = function(x){
  return(x[1])
})
firstName
# [1] "John"  "Henry"
lastName
# [1] "Smith" "Lee"
data.frame(firstName, lastName, stringsAsFactors = F)


# first argument is the pattern you want to match
# second argument is the replacement string
# third argument is the character vector you want to do the replacement on
# I usually add fixed=T so I don't have to worry about regular expressions
gsub("BcD","---",c("aBcDe","not here","aBcDeBcDa"))
sub("BcD","---",c("aBcDe","not here","aBcDeBcDa"))
  #this one only finds the first one in each element

gsub("BcD","---",c("aBcDe","not here","aBcDeBcDa"), fixed=T)
#sometimes it might not be true (?)
  #this isn't a vectorized function: can't give each argument more than 1 argument
#gsub(c("BcD","not")---",c("aBcDe","not here","aBcDeBcDa"))

#%>% # piping/chaining command that takes output of one command and turns into input for next command



#look for BcD, inside all of c (all 3 elements - exists in 2, but not the middle)
# [1] "a---e"     "not here"  "a---e---a"

#the first two arguments are NOT vectorized
# if you enter a vector with length > 1, it will only use the first element as input

library(dplyr)
dl_dir <- "./" #"WHERE YOU SAVED FILES" # make sure to change this
company_a <- read.csv(paste0(dl_dir,"company_a.csv"))
company_b <- read.csv(paste0(dl_dir,"company_b.csv"))

both <- rbind(company_a, company_b)
table(both$Customer.ID)

aggregate(both[,-1], by = list(both$Customer.ID),sum)
  #first arg= columns i want to aggreate on
  #2nd arg, function
  #3rd arg, 

# without %>%
both_grouped <- group_by(both, Customer.ID)
both_grouped
group_by(both,"Customer.ID")
  #supply function w/ column names- didn't supply quotations
  #if you do do quotations, it creates a new column called "Customer.Id"
  #everyone gets teh same value, groups by this, but not useful b/c same value
summarise_each(both_grouped, funs(sum))
  #applies function to each column that isn't part of grouping structure
summarise_each(both_grouped, funs(sum,mean))

# with %>%
both %>% group_by(Customer.ID) %>% summarise_each(funs(sum))
  #margarita operator/piping 
  #both = pipe into this function
  #group_by - only one input
  #take both, use as 1st argument in groupby function, anything put inside
  # is a lesser function
  #output of groupby, use as first input for summarize each
  #assumes that first input is whatever result of what's to the left of it
  #can see original source more clearly

#Example 2
dl_dir <-"./"  #"WHERE YOU SAVED FILES" # make sure to change this
bio <- read.csv(paste0(dl_dir,"bio.csv"))
books <- read.csv(paste0(dl_dir,"books.csv"))

#BaseR
#by.x corresponds to first input and by.y corresponds to second
merge(books, bio, by.x = "Author.ID", by.y = "ID") #inner join
  #now 6 book rows, author ID for hobbit cannot be joined
  #merging on author id (in books), id (in bio)
  #first column always joining element, w/ identifier provided in supplier
  #(e.g., master/using)
merge(books, bio, by.x = "Author.ID", by.y = "ID", all = T) #full outer join
  #NA for hobbit
  #one author not associated w/ any authors, so have <NA> missing columns
merge(books, bio, by.x = "Author.ID", by.y = "ID", all.x = T)  #left join
  #puts out every book even if no author id link to it (x join/left join)
merge(books, bio, by.x = "Author.ID", by.y = "ID", all.y = T) #right join
  #or, y join/right join
  #need to pay attention to which data frame is first
    #.x always comes before .y**
    #sql joins are exactly the same

library(dplyr)
inner_join(books, bio, by = c("Author.ID" = "ID") )
  #books = data frame 1, bio = data frame 2
  # c("Author.ID" = "ID")
  #giving a name to the vector 
  #name of first vector is authorID, second is ID (?)
full_join(books, bio, by = c("Author.ID" = "ID") )
left_join(books, bio, by = c("Author.ID" = "ID") )
right_join(books, bio, by = c("Author.ID" = "ID") )
#names are more descriptive


#Ex 3.
dl_dir <-"./"# "WHERE YOU SAVED FILES" # make sure to change this
co_a_expanded <- read.csv(paste0(dl_dir,"co_a_2.csv"))
co_b_expanded <- read.csv(paste0(dl_dir,"co_b_2.csv"))
View(co_a_expanded)
View(co_b_expanded)
#gather function takes info in columns and reduces to key value-pair

library(tidyr)
# first argument is data.frame
# second argument is the name you want to give to the key column
# third argument is the name you want to give to the value column

#now you have to specify which columns to gather.
#few ways to do this
gather(co_a_expanded,"key","value",-1) #all but first column
  #-1 tells me which columns to do key value expansion - don't do on 1st value, only others
gather(co_a_expanded,"key","value",-Customer.ID) #all but the Customer.ID column
  #do key value expansion for all columns except customer ID
gather(co_a_expanded,"key","value",revenue_01:orders_04) #gather all columns from revenue_01:orders_04
  #do this from columns revenue01 thru orders04

#if need new var, create before you gather

# gather both data.frames and rbind them
x <- gather(co_a_expanded,"key","value",-1)
#1: what do you want to label key column? #2: what to name second value?
y <- gather(co_b_expanded,"key","value",-1)
  #b/c headings down align, need change to key value format
z <- rbind(x,y)
# set the key total to revenue
z$key[z$key == 'total_01'] = 'revenue_01' #renaming name of total to revenue to make match other data source
z$key[z$key == 'total_02'] = 'revenue_02'
z$key[z$key == 'total_03'] = 'revenue_03'
z$key[z$key == 'total_04'] = 'revenue_04'

#now that i have key values, i can put it back into column structure
  #now i can only use the values/columns that I want - easier to drop/keep,etc.

table(z$Customer.ID,z$key) #notice some keys appear 2x for a given customer id.
  # 23fsdf98 is customer of both companies, i want to combine now

#to fix this, sum the values
  #for duplicates, add

# i only want to make a report on number of orders (don't care about rev)
  #filter: take to_spead and use logic, if revenue, keep it, otherwise, don't show

# use spread to create columns
# 2nd argument is name of column containing keys
# 3rd argument is name of column containig values
# do NOT use quotes
res <- spread(to_spread, key, value)
  #spread, here's data frame gathered, put back into column format
  #instead of rev1 under rev2, etc, puts them next to each other, all grouped under id
View(res)

#Note: data.table is better for big data, but more of a learning curve