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
# exercice make the output code
# 1 Concatenate the company and department variables into one string separated by an underscore.

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

# 🔹 MCIT String Exercises – Extended
 
# 1.Count how many countries exist in the countries list and output the number.

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

# 5. Replace "Canada" with "CA" inside the countries list (apply replacement for all values).
 output "countries_replace_canada" {
  value = [for country in var.countries : replace(country, "Canada", "CA")]
}

# 6. Create a greeting that says: "Hello from CITY, COUNTRY!" using the first values in both lists.
 output "city_country_greeting" {
  value = format("Hello from %s, %s!", var.cities[0], var.countries[0])
}

# 7. Check if "Python" exists inside skills_string and output "Skill Found" or "Not Found".
 output "check_python_skill" {
  value = contains(split(",", var.skills_string), "Python") ? "Skill Found" : "Not Found"
}

# 8. Create an output that repeats the company variable 3 times in a row (e.g., "MCITMCITMCIT").
 output "company_repeated_3x" {
  value = join("", [for i in range(3) : var.company])
}

# 9. Extract the second skill from skills_string after splitting.
 output "second_skill" {
  value = split(",", var.skills_string)[1]
}

# 10. Format a sentence that shows the first city, its country, and the department (e.g., "Vancouver, Canada belongs to CloudEngineering department").
output "city_country_department_sentence" {
  value = format("%s, %s belongs to %s department", var.cities[0], var.countries[0], var.department)
}


# -------------------
# MCIT Lookup Exercises (code)
# -------------------
 
# MCIT Lookup Exercise 1: Fetch instance type for 'dev'
output "env_dev_instance" {
  value = lookup(var.env_settings, "aaa", "N/A")
}

# MCIT Lookup Exercise 2: Fetch instance for 'prod', default to 'default_instance' if not found
output "env_prod_instance_or_default" {
  value = lookup(var.env_settings, "prod", "default_instance")
}
 
# MCIT Lookup Exercise 3: Airport code for Toronto
output "toronto_airport_code" {
  value = lookup(var.city_codes, "Toronto")
}
 
# MCIT Lookup Exercise 4: Lookup Ottawa code with fallback "N/A"
output "ottawa_airport_code_or_na" {
  value = lookup(var.city_codes, "Ottawa", "N/A")
}
 
# MCIT Lookup Exercise 5: Currency for Canada
output "currency_canada" {
  value = lookup(var.country_currency, "Canada")
}
 
# MCIT Lookup Exercise 6: Currency for Brazil with default "Unknown"
output "currency_brazil_or_unknown" {
  value = lookup(var.country_currency, "Brazil", "Unknown")
}
 
# MCIT Lookup Exercise 7: Format a sentence using a lookup result
output "formatted_env_dev_instance" {
  value = format("Environment dev uses %s", lookup(var.env_settings, "dev", "unknown_instance"))
}
 
# MCIT Lookup Exercise 8: Use lookup() in a for-loop with default "XXX" for missing cities
output "resolved_airport_codes" {
  value = [for c in var.request_cities : lookup(var.city_codes, c, "XXX")]
}
  
# MCIT Lookup Exercise 9: Conditional check if 'stage' exists using lookup() + sentinel
output "stage_key_presence" {
  value = lookup(var.env_settings, "stage", local.sentinel_missing) != local.sentinel_missing ? "Found" : "Not Found"
}
 
# MCIT Lookup Exercise 10: Uppercase the currency for Mexico via lookup()
output "currency_mexico_upper" {
  value = upper(lookup(var.country_currency, "Mexico", "Unknown"))
}
*/

# class 22 october

##########################################
# MCIT Lookup Challenge Questions
##########################################

# 1️⃣ Plan Quota
# Use lookup() to return the quota for a selected plan (free, pro, enterprise).
# If the plan is not found, return 0.
output "selected_plan" {
  value = lookup(local.plan_quotas, "basic", 0)
}
# 2️⃣ Region Endpoint with Secondary Fallback
# Fetch the API endpoint for a given region.
# First check region_endpoints.
# If not found, check override_endpoints.
# If still not found, return "not-available".
# Output with fallback lookup logic:
output "api_endpoint" {
  value = lookup(
    local.region_endpoints,
    var.region,
    lookup(
      local.override_endpoints,
      var.region,
      "not-available"
    )
  )
}
# 3️⃣ Nested Greeting Lookup
# From a nested map of greetings (with keys like en, fr, es),
# fetch the "hello" greeting for the selected language.
# If the language doesn’t exist, return "Hi".
output "look_greeting" {
  value = lookup(var.greeting, "En", "Hi")
}
# 4️⃣ Airport Codes for Requested Cities
# Given a list of requested cities, return a list of airport codes.
# If a city isn’t in the map, return "XXX" for that city.
output "airport_code_or_xxx" {
  value = lookup(var.city_codes, "Montreal", "XXX")
}
# 5️⃣ Environment Presence Check
# Use lookup() with a sentinel value to check if a given environment
# (e.g., dev, qa, stage, prod) exists in a map.
# Output "Exists" or "Missing".
output "environment_status" {
  value = (
    lookup(local.env_settings, var.environment, local.sentinel_missing) != local.sentinel_missing ?
    "Exists" :
    "Missing"
  )
}

# 6️⃣ Region Endpoint or Message
# Lookup an endpoint for the selected region.
# If the region isn’t supported, output "Unsupported region: <region>".
output "region_endpoint_message" {
  value = lookup(
    local.region_endpoints,
    var.region,
    "Unsupported region: ${var.region}"
  )
}

# 7️⃣ Service Port After Merge
# Merge two maps (base_ports and custom_ports)
# and use lookup() to get the port for a given service.
# If the service is missing, return -1.

# 8️⃣ Case-Insensitive Country Code
# Build a map where country names are normalized to lowercase.
# Use lookup() to fetch the country code for an input like "usa".
# If not found, return "UNKNOWN".

# 9️⃣ Product Price with Multi-Map Fallbacks
# Lookup a product’s price:
# First, check the regional price for the selected region.
# If not found, check global prices.
# If not found, return -1.

# 🔟 Feature Flag Status
# Lookup a boolean feature flag (e.g., chat, search) from a map.
# If found, output "enabled" or "disabled".
# If missing, treat as "disabled".
