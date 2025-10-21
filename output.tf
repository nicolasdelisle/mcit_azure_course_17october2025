/*
# MCIT Exercise 1: Concatenate first + last name
output "full_name" {
  value = "${var.firstname} ${var.lastname}"
}
# MCIT Exercise 2: Uppercase all environment names
output "uppercase_envs" {
  value = [for env in var.environments_second : upper(env)]
}
 
# MCIT Exercise 3: Lowercase all service names
output "lowercase_services" {
  value = [for svc in var.service_names_town : lower(svc)]
}
 
# MCIT Exercise 4: Length of firstname
output "firstname_length" {
  value = length(var.firstname)
}
 
# MCIT Exercise 5: Substring of lastname (first 3 letters)
output "lastname_substring" {
  value = substr(var.lastname, 1, 1)
}
 
# MCIT Exercise 6: Join service names into one string
output "services_joined" {
  value = join("-", var.service_names_town)
}
 
# MCIT Exercise 7: Split env_string into a list
output "split_envs" {
  value = split(",", var.env_string)
}
 
# MCIT Exercise 8: Replace part of a string
output "replace_city" {
  value = replace("montreal_city", "city", "town")
}
 
# MCIT Exercise 9: Format greeting string
output "Greeting" {
  value = format("Hello %s %s, welcome to %s!", var.firstname, var.lastname, var.environments_second[0])
}
 
# MCIT Exercise 10: Conditional string comparison
output "is_prod" {
  value = var.environments_second[3] == "prod" ? "Production environment" : "Not production"
}
/* exercice make the output code
 1 Concatenate the company and department variables into one string separated by an underscore.
*/
output "company_department" {
  value = "${var.company}_${var.department}"
}

# 2 Convert all country names in countries to uppercase.
output "countries_upper" {
  value = [for countrie in var.countries : upper(countrie)]
}

# 3 Convert all city names in cities to lowercase.
output "cities_lower" {
  value = [for city in var.cities : lower(city)]
}

# 4 Find the length of the department string.
output "department_length" {
  value = length(var.department)
}

# 5 Extract the first two characters of the company variable.
output "company_first_two" {
  value = substr(var.company, 0, 2)
}

# 6 Join all cities in cities into a single string separated by " | ".
output "cities_joined" {
  value = join(" | ", var.cities)
}

# 7 Split the skills_string variable into a list of skills.
output "split_skill" {
  value = split(",", var.skills_string)
}

# 8 Replace "Engineering" with "DevOps" in the department variable.
output "replace_Engineering" {
  value = replace(var.department, "Engineering", "DevOps")
}

# 9 Format a string that introduces the company and department.
output "welcome" {
  value = format("Welcome to %s!, departement %s!", var.company, var.department)
}
 
# 10 Check if the first city in cities is "Vancouver" and output "West Coast City" or "Different City" depending on the result.
output "city_check" {
  value = var.cities[0] == "Vancouver" ? "West Coast City" : "Different City"
}

/* 🔹 MCIT String Exercises – Extended
 
1.Count how many countries exist in the countries list and output the number.
*/
output "number_of_countries" {
  value = length(var.countries)
}

 
# 2 Take the last 3 characters of the department string.
output "department_last_3" {
  value = substr(var.department, length(var.department) - 3, 3)
}

 
# 3 Join all countries into a single string separated by commas.
output "countries_joined" {
  value = join(",", var.countries)
}


# 4. Sp4 lit the first city in the cities list into individual characters.
# the first city on the list split by individual character
 output "first_city_characters" {
  value = [for city in range(0, length(var.cities[0])) : substr(var.cities[0], city, 1)]
}
*/
# 5. Replace "Canada" with "CA" inside the countries list (apply replacement for all values).
 
# 6. Create a greeting that says: "Hello from CITY, COUNTRY!" using the first values in both lists.
 
# 7. Check if "Python" exists inside skills_string and output "Skill Found" or "Not Found".
 
# 8. Create an output that repeats the company variable 3 times in a row (e.g., "MCITMCITMCIT").
 
# 9. Extract the second skill from skills_string after splitting.
 
# 10. Format a sentence that shows the first city, its country, and the department (e.g., "Vancouver, Canada belongs to CloudEngineering department").
 
