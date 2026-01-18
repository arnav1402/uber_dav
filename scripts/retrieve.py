from sqlalchemy import create_engine
import pandas as pd

engine = create_engine(
    "postgresql+psycopg2://postgres:postgres@localhost:5431/postgres"
)
with engine.connect() as conn:
    print("CONNECTED")
    
    # Load the table into a DataFrame
    df = pd.read_sql("SELECT * FROM uber_data.final_tb", conn)
    
    # Save DataFrame to CSV
    df.to_csv("../data/final_tb/final_tb.csv", index=False)  # index=False avoids saving the row numbers
    print("saved successfully")