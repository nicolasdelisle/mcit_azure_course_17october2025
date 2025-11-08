def atm():
    print("Welcome to the Delisle Bank!")

    # Get user name
    first_name = input("Enter your first name: ").strip().capitalize()
    last_name = input("Enter your last name: ").strip().capitalize()
    balance = 307.77  # initial balance
    #use action to determine deposit withdraw or exit 
    while True:
        action = input(" Do you want to deposit or withdraw? (type 'exit' to quit): ").strip().lower()
 #do a while true loop to all those point ask deposit amount(if it is negative, say "amount is invalid, try again"deposit limit needs to be 1000(you cannot deposit more than 1000
        if action == "deposit":
            while True:
                try:
                    amount = float(input("Enter deposit amount: "))
                    if amount < 0:
                        print("Amount is invalid, try again.")
                        continue
                    elif amount > 1000:
                        print("you cannot deposit more than 1000. Try again.")
                        continue
                    else:
                        balance += amount
                        print(f"{first_name} {last_name}, you deposited ${amount:.2f}.")
                        print(f"New balance: ${balance:.2f}")
                        break
                except ValueError:
                    print("Invalid input, please enter a number.")
#second while loop for withdraw limitneeds to be 500(you cannot withdraw more than 500) if balance is lower than withdraw amount then say "You dont have necessary fund to withdraw"
        elif action == "withdraw":
            while True:
                try:
                    amount = float(input("Enter withdraw amount: "))
                    if amount < 0:
                        print("Amount is invalid, try again.")
                        continue
                    elif amount > 500:
                        print("you cannot withdraw more than 500. Try again.")
                        continue
                    elif amount > balance:
                        print("You don't have necessary funds to withdraw.")
                        break
                    else:
                        balance -= amount
                        print(f"Withdrawal successful! You withdrew ${amount:.2f}.")
                        print(f"Remaining balance: ${balance:.2f}")
                        break
                except ValueError:
                    print("Invalid input, please enter a number.")

        elif action == "exit":
            print(f"Thank you, {first_name} {last_name}!")
            break

        else:
            print("Invalid choice. Please type 'deposit', 'withdraw', or 'exit'.")

# Run the ATM
atm()
