import tkinter as tk
from pymongo import MongoClient

# Connect to MongoDB
client = MongoClient('mongodb://localhost:27017')
db = client['Assign8']
collection = db['Assignment8']

# client = MongoClient('mongodb+srv://nehakharat1303:1KrnySjfLbeEDrZ3@assignment8.yoonomf.mongodb.net/?retryWrites=true&w=majority&appName=Assignment8s')

# # Specify the database and collection
# db = client.get_database('Assign9')
# collection = db['Assigment9']

# CRUD Operations
def create_record():
    data = {
        'name': name_entry.get(),
        'age': int(age_entry.get()),
        'email': email_entry.get()
    }
    collection.insert_one(data)
    display_records()

# def read_record():
#     result_text.delete('1.0', tk.END)
#     result = collection.find_one({'name': search_name.get()})
#     if result:
#         result_text.insert(tk.END, f"Name: {result['name']}\n")
#         result_text.insert(tk.END, f"Age: {result['age']}\n")
#         result_text.insert(tk.END, f"Email: {result['email']}\n")
#     else:
#         result_text.insert(tk.END, "Record not found.")
    
def read_record():
    result_text.delete('1.0', tk.END)
    results = collection.find({'name': search_name.get()})
    if results:
        for result in results:
            result_text.insert(tk.END, f"Name: {result['name']}\n")
            result_text.insert(tk.END, f"Age: {result['age']}\n")
            result_text.insert(tk.END, f"Email: {result['email']}\n")
            result_text.insert(tk.END, "--------------------\n")  # Separate records
    else:
        result_text.insert(tk.END, "No records found for this name.")

def update_record():
    query = {'name': search_name.get()}
    new_data = {
        'name': new_name_entry.get(),
        'age': int(new_age_entry.get()),
        'email': new_email_entry.get()
    }
    collection.update_one(query, {'$set': new_data})
    display_records()

def delete_record():
    query = {'name': search_name.get()}
    collection.delete_one(query)
    display_records()

def display_records():
    result_text.delete('1.0', tk.END)
    records = collection.find()
    for record in records:
        result_text.insert(tk.END, f"Name: {record['name']}\n")
        result_text.insert(tk.END, f"Age: {record['age']}\n")
        result_text.insert(tk.END, f"Email: {record['email']}\n")
        result_text.insert(tk.END, "\n")

# GUI
root = tk.Tk()
root.title("MongoDB CRUD Application")

# Set window geometry to fill screen and make resizable
root.geometry("800x600")
root.resizable(True, True)

# Create
tk.Label(root, text="Name:").grid(row=0, column=0)
tk.Label(root, text="Age:").grid(row=1, column=0)
tk.Label(root, text="Email:").grid(row=2, column=0)

name_entry = tk.Entry(root)
name_entry.grid(row=0, column=1)
age_entry = tk.Entry(root)
age_entry.grid(row=1, column=1)
email_entry = tk.Entry(root)
email_entry.grid(row=2, column=1)

create_button = tk.Button(root, text="Create", command=create_record)
create_button.grid(row=3, column=0, columnspan=2, pady=5)

# Read
tk.Label(root, text="Search Name:").grid(row=4, column=0)
search_name = tk.Entry(root)
search_name.grid(row=4, column=1)

read_button = tk.Button(root, text="Read", command=read_record)
read_button.grid(row=5, column=0, columnspan=2, pady=5)

result_text = tk.Text(root, width=30, height=10)
result_text.grid(row=6, column=0, columnspan=2)

# Update
tk.Label(root, text="New Name:").grid(row=7, column=0)
tk.Label(root, text="New Age:").grid(row=8, column=0)
tk.Label(root, text="New Email:").grid(row=9, column=0)

new_name_entry = tk.Entry(root)
new_name_entry.grid(row=7, column=1)
new_age_entry = tk.Entry(root)
new_age_entry.grid(row=8, column=1)
new_email_entry = tk.Entry(root)
new_email_entry.grid(row=9, column=1)

update_button = tk.Button(root, text="Update", command=update_record)
update_button.grid(row=10, column=0, columnspan=2, pady=5)

# Delete
delete_button = tk.Button(root, text="Delete", command=delete_record)
delete_button.grid(row=11, column=0, columnspan=2, pady=5)

display_records()

root.mainloop()
