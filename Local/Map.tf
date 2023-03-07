resource "local_file" "map_names" {
  filename = "/home/faizan/pet_name"
  #content  = "My Name is ${var.map_pet_names["f_name"]} ${var.map_pet_names["l_name"]}\nMy age is ${var.map_pet_names["age"]} and Marrital status is ${var.map_pet_names["married"]}"

  content = <<EOF
My Name is ${var.map_pet_names["f_name"]} $var.map_pet_names["l_name"].
My Age is ${var.map_pet_names["age"]}
My Marital Status is ${var.map_pet_names["married"]}
EOF


}


/********** Function **********/
/**
> keys(var.map_pet_names)
tolist([
  "age",
  "f_name",
  "l_name",
  "married",
])
> values(var.map_pet_names)
tolist([
  "29",
  "faizan",
  "shaikh",
  "false",
])
> lookup(var.map_pet_names, "f_name")
"faizan"
> lookup(var.map_pet_names, "married")
"false"
> lookup(var.map_pet_names, "age")
"29"
**/