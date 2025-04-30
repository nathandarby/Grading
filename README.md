# Grading
AI Grading Tool based on complex socio-technical framework FRAM 

# AI Grading Tool (MVP)

This project aims to build a Minimum Viable Product (MVP) for an AI-assisted grading system that models human grading behavior using the **Functional Resonance Analysis Method (FRAM)**. The system will support high-variability grading contexts such as high school math explanations and college-level logic proofs.

---

##  Project Goals

- Reduce grading time and human bias.
- Improve feedback quality and consistency.
- Understand and simulate grader variability using FRAM.
- Incorporate OCR and AI logic to assist and eventually automate grading functions.

---

##  Project Structure


---

##  Core Components

###  FRAM-Based Grading Model
The grading process is broken down into six steps:
1. **Scanning**
2. **Matching**
3. **Evaluation**
4. **Scrutiny**
5. **Judgment**
6. **Re-evaluation**

Each step will be captured in the database and augmented by AI modules.

---

###  Database Schema
Stored in `schema/fram_schema.sql`. Key entities include:
- `Submission`, `Submission_Answer`
- `Grading_Step` (linked to FRAM function)
- `Feedback`, `Tags`
- `AI_Feedback`, `Confidence_Logs`
- `Content`, `OCR_Input`

---

###  AI Logic Modules
Each FRAM function will eventually be paired with:
- Rule-based or ML model
- Optional AI-human comparison logging
- Confidence thresholds

---

### 🖼 OCR Integration (Planned)
- Parse handwritten or scanned student work into structured text
- Log OCR confidence and original image path

---

##  Next Milestones
- [ ] Finalize schema with OCR/AI fields
- [ ] Seed initial submissions and grading steps
- [ ] Prototype AI Matching logic
- [ ] Create lightweight grader interface (optional)

---

## 🤝Contributions
This project is being developed by Nathan Darby as part of a larger exploration into AI-human collaboration in grading workflows. Collaboration is welcome in AI modeling, UI design, FRAM modeling, or educational validation.

---

##  License

