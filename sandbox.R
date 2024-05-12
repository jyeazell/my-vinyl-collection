library(tidyr)
library(dplyr)
library(discogger)
library(purrr)



# collection_raw <- discogs_user_collection(user_name = "Yeez52")
load("collection_raw.RData")
collection <- collection_raw[[1]]

sample_record <- collection[[2]]
# names(sample_record)


cleanCollectionRecord <- function(x) {
  
  a <- as_tibble(x[1:4]) %>% 
    unnest(cols = where(is.list)) %>% 
    select(-rating)
  
  b <- as_tibble(x[[5]])[1,]
  b <- b %>% 
    mutate(formats = paste(b$formats[[1]]$name, b$formats[[1]]$text, sep = ","),
           artists = b$artists[[1]]$name)
  
  c <- a %>% 
    left_join(b, by = "id") %>% 
    select(id,
           master_id,
           instance_id,
           artist = artists,
           title,
           year,
           format = formats
           # everything(),
           # -c(labels, genres, styles))
    )
  
  return(c)
  
}

sample_clean <- map(.x = sample_record,
                        .f = cleanCollectionRecord)

# a <- as_tibble(sample_record[1:4]) %>% 
#   unnest(cols = where(is.list)) %>% 
#   select(-rating)
# 
# b <- as_tibble(sample_record[[5]])[1,] %>%
#   mutate(formats = paste(b$formats[[1]]$name, b$formats[[1]]$text, sep = ","),
#          artists = b$artists[[1]]$name)
# 
# c <- a %>% 
#   left_join(b, by = "id") %>% 
#   select(id,
#          master_id,
#          instance_id,
#          artist = artists,
#          title,
#          year,
#          format = formats,
#          everything(),
#          -c(labels, genres, styles)
#   )
