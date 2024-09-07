import sqlite3

# Connect to the SQLite database (or create it if it doesn't exist)
conn = sqlite3.connect('hospital_inventory.db')
cursor = conn.cursor()

# Create the Inventory Table (if it doesn't already exist)
cursor.execute('''CREATE TABLE IF NOT EXISTS inventory (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  item_name TEXT NOT NULL,
                  category TEXT NOT NULL,
                  quantity INTEGER NOT NULL,
                  price_per_unit REAL NOT NULL,
                  supplier TEXT,
                  date_added DATE DEFAULT (DATE('now'))
                )''')

# Function to add an item to the inventory
def add_item(item_name, category, quantity, price_per_unit, supplier):
    cursor.execute('''
        INSERT INTO inventory (item_name, category, quantity, price_per_unit, supplier)
        VALUES (?, ?, ?, ?, ?)
    ''', (item_name, category, quantity, price_per_unit, supplier))
    conn.commit()
    print(f"Item '{item_name}' added to the inventory.")

# Function to update the quantity of an existing item
def update_item_quantity(item_id, new_quantity):
    cursor.execute('''
        UPDATE inventory
        SET quantity = ?
        WHERE id = ?
    ''', (new_quantity, item_id))
    conn.commit()
    print(f"Item ID '{item_id}' updated with new quantity: {new_quantity}.")

# Function to delete an item from the inventory
def delete_item(item_id):
    cursor.execute('''
        DELETE FROM inventory WHERE id = ?
    ''', (item_id,))
    conn.commit()
    print(f"Item ID '{item_id}' deleted from the inventory.")

# Function to view all items in the inventory
def view_inventory():
    cursor.execute('''
        SELECT * FROM inventory
    ''')
    rows = cursor.fetchall()
    if rows:
        print("\nHospital Inventory:")
        print("-" * 60)
        for row in rows:
            print(f"ID: {row[0]}, Item: {row[1]}, Category: {row[2]}, Quantity: {row[3]}, Price: {row[4]}, Supplier: {row[5]}, Date Added: {row[6]}")
    else:
        print("No items found in the inventory.")

# Function to search for an item by name
def search_item_by_name(item_name):
    cursor.execute('''
        SELECT * FROM inventory WHERE item_name LIKE ?
    ''', ('%' + item_name + '%',))
    rows = cursor.fetchall()
    if rows:
        for row in rows:
            print(f"ID: {row[0]}, Item: {row[1]}, Category: {row[2]}, Quantity: {row[3]}, Price: {row[4]}, Supplier: {row[5]}, Date Added: {row[6]}")
    else:
        print(f"No items found with the name '{item_name}'.")

# Menu for user interaction
def main():
    while True:
        print("\nHospital Inventory Management")
        print("1. Add Item")
        print("2. Update Item Quantity")
        print("3. Delete Item")
        print("4. View Inventory")
        print("5. Search Item by Name")
        print("6. Exit")
        choice = input("Enter your choice: ")

        if choice == '1':
            item_name = input("Enter item name: ")
            category = input("Enter category (Medicine, Equipment, Supply): ")
            quantity = int(input("Enter quantity: "))
            price_per_unit = float(input("Enter price per unit: "))
            supplier = input("Enter supplier name: ")
            add_item(item_name, category, quantity, price_per_unit, supplier)

        elif choice == '2':
            item_id = int(input("Enter item ID to update: "))
            new_quantity = int(input("Enter new quantity: "))
            update_item_quantity(item_id, new_quantity)

        elif choice == '3':
            item_id = int(input("Enter item ID to delete: "))
            delete_item(item_id)

        elif choice == '4':
            view_inventory()

        elif choice == '5':
            item_name = input("Enter item name to search: ")
            search_item_by_name(item_name)

        elif choice == '6':
            print("Exiting...")
            break

        else:
            print("Invalid choice! Please try again.")

# Run the application
if __name__ == "__main__":
    main()

# Close the database connection when done
conn.close()
