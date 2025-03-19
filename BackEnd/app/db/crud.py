from app.models.patient_model import PatientModel

def insert_patient(patient: PatientModel):
    db["patients"].insert_one(patient.dict())
