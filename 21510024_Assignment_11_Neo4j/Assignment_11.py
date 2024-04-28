import tkinter as tk
from neo4j import GraphDatabase

# Neo4j database connection details
uri = "bolt://127.0.0.1:7687"
username = "neo4j"
password = "India@2024"

# Initialize the Neo4j driver
try:
    driver = GraphDatabase.driver(uri, auth=(username, password))
except Exception as e:
    print(f"Failed to connect to Neo4j: {e}")
    exit()

# Function to check if paper A cites paper B
def does_paper_a_cite_paper_b(tx, paper_a_id, paper_b_id):
    query = (
        "MATCH (a:Paper {id: $paper_a_id})-[:CITES*..3]->(b:Paper {id: $paper_b_id}) "
        "RETURN count(*) > 0"
    )
    result = tx.run(query, paper_a_id=paper_a_id, paper_b_id=paper_b_id)
    return result.single()[0]

# Function to get the full classification of a paper
def get_classification_of_paper(tx, paper_id):
    query = (
        "MATCH (p:Paper {id: $paper_id})-[:HAS_CLASSIFICATION]->(c:Classification) "
        "RETURN c.name"
    )
    result = tx.run(query, paper_id=paper_id)
    return [record['c.name'] for record in result]

# Function to handle search button click
def search():
    # Get the paper IDs from the entry widgets
    paper_a_id = entry_paper_a_id.get()
    paper_b_id = entry_paper_b_id.get()
    paper_id = entry_paper_id.get()

    # Validate input
    if not paper_a_id or not paper_b_id or not paper_id:
        label_status.config(text="Please enter all paper IDs", fg="red")
        return

    # Open a new Neo4j session
    with driver.session() as session:
        try:
            # Check if paper A cites paper B
            result_a_b = does_paper_a_cite_paper_b(session, paper_a_id, paper_b_id)
            label_a_b.config(text="Paper A cites Paper B: " + ("Yes" if result_a_b else "No"))

            # Get the full classification of the paper
            result_classification = get_classification_of_paper(session, paper_id)
            label_classification.config(text="Classification: " + "/".join(result_classification))

            label_status.config(text="Search completed successfully", fg="green")
        except Exception as e:
            print(f"Query execution failed: {e}")
            label_status.config(text="Error executing query", fg="red")

# Create the main window
window = tk.Tk()
window.title("Research Papers Database")

# Create the widgets
label_paper_a_id = tk.Label(window, text="Enter Paper A ID:")
entry_paper_a_id = tk.Entry(window, width=50)
label_paper_b_id = tk.Label(window, text="Enter Paper B ID:")
entry_paper_b_id = tk.Entry(window, width=50)
button_search_citations = tk.Button(window, text="Search Citations", command=search)
label_a_b = tk.Label(window, text="")
label_paper_id = tk.Label(window, text="Enter Paper ID:")
entry_paper_id = tk.Entry(window, width=50)
button_search_classification = tk.Button(window, text="Search Classification", command=search)
label_classification = tk.Label(window, text="")
label_status = tk.Label(window, text="", fg="black")

# Pack the widgets
label_paper_a_id.pack(pady=10)
entry_paper_a_id.pack(pady=5)
label_paper_b_id.pack(pady=10)
entry_paper_b_id.pack(pady=5)
button_search_citations.pack(pady=10)
label_a_b.pack(pady=5)
label_paper_id.pack(pady=10)
entry_paper_id.pack(pady=5)
button_search_classification.pack(pady=10)
label_classification.pack(pady=5)
label_status.pack(pady=10)

# Run the main loop
window.mainloop()
