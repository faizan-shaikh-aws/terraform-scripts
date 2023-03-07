variable "file_path" {
  type        = string
  default     = "/home/faizan/pets1"
  description = "Path for Pet file"
  sensitive   = false

}

variable "pet_name" {
  type        = string
  default     = "Mr. Whiskers"
  description = "Name of my cat"
  sensitive   = true
}

variable "pet_count" {
  type        = number
  default     = 1
  description = " No. of pets"
  sensitive   = false
}

variable "cat_names" {
  type    = list(any)
  default = ["Whiskers", "Tom", "Jerry"]
}

variable "set_dog_name" {
  type    = set(string)
  default = ["Tommy", "Tim", "Tommy", "Reff"]
}

variable "tuple_pet_names" {
  type    = tuple([string, number, bool])
  default = ["Kane", 5, false]

}

variable "map_pet_names" {
  type = map(any)
  default = {
    "f_name"  = "faizan",
    "l_name"  = "shaikh",
    "age"     = 29
    "married" = false
  }
}
