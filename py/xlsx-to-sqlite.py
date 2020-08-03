import os
import sqlite3
import pandas as pd

def main():
    excel_file = 'dataset.xlsx'
    db = sqlite3.connect('arpt.db')
    wb = pd.ExcelFile(excel_file)
    
    for sheet in wb.sheet_names:
        df=pd.read_excel(excel_file,sheet_name=sheet)
        df.to_sql(sheet,db, index=False,if_exists="replace")
        
    db.commit()
    db.close()

if __name__ == "__main__":
    main()
