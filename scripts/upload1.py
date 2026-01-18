from sqlalchemy import create_engine
import pandas as pd

engine = create_engine(
    "postgresql+psycopg2://postgres:postgres@localhost:5431/postgres"
)

with engine.connect() as conn:
    print("CONNECTED")

dfs = {
    "fact": pd.read_csv("../dataframes/fact_table.csv"),
    "datetime": pd.read_csv("../dataframes/datetime_dim.csv"),
    "trip_distance": pd.read_csv("../dataframes/trip_distance_dim.csv"),
    "passenger_count": pd.read_csv("../dataframes/passenger_count_dim.csv"),
    "rate_code": pd.read_csv("../dataframes/rate_code_dim.csv"),
    "pickup_loc": pd.read_csv("../dataframes/pickup_location_dim.csv"),
    "dropoff_loc": pd.read_csv("../dataframes/dropoff_location_dim.csv"),
    "payment": pd.read_csv("../dataframes/payment_type_dim.csv"),
}

for table, df in dfs.items():
    df = df.loc[:, ~df.columns.str.contains("^Unnamed")]
    df.to_sql(
        table, 
        engine,
        schema="uber_data", 
        if_exists="replace",
        index=False
    )

print("DATAFRAMES UPLOADED")