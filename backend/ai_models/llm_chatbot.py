import openai

# Set your OpenAI API key
openai.api_key = "YOUR_OPENAI_API_KEY"

def llm_symptom_checker(symptoms: str, history: str = "") -> str:
    prompt = f"""
You are a virtual medical assistant. A patient describes their symptoms: {symptoms}
{f"Their medical history: {history}" if history else ""}
1. List the most likely diseases (in bullet points).
2. For each, estimate the risk (low/medium/high/critical).
3. Give brief, clear advice: if risk is high/critical, recommend urgent care and suggest the type of doctor/hospital; if low, give self-care tips and over-the-counter medication suggestions (avoid repeats from medical history).
4. Respond in clear, patient-friendly language.
"""
    response = openai.ChatCompletion.create(
        model="gpt-4",
        messages=[{"role": "system", "content": "You are a helpful medical assistant."},
                  {"role": "user", "content": prompt}],
        temperature=0.2,
        max_tokens=512
    )
    return response.choices[0].message.content.strip()