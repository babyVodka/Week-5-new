
import SwiftUI

let students: [Student] = [
    Student(id: "SESEIU24023", name: "Tam", age: 20),
    Student(id: "FAACIU24052", name: "Tuan", age: 21),
    Student(id: "SESEIU24000", name: "Tung", age: 19),
    Student(id: "SESEIU24013", name: "Khoi", age: 20)
]

let subjects: [Subject] = [
    Subject(id: "C001", name: "Calculus 1", credits: 4),
    Subject(id: "C002", name: "Physics", credits: 3),
    Subject(id: "C003", name: "Programming", credits: 3),
    Subject(id: "C004", name: "Scientic Socialism", credits: 2)
]

func createSampleRecords() -> [StudentRecord] {
    return [
        StudentRecord(student: students[0], subject: subjects[0], mark: 85),
        StudentRecord(student: students[0], subject: subjects[1], mark: 70),

        StudentRecord(student: students[1], subject: subjects[0], mark: 40),
        StudentRecord(student: students[1], subject: subjects[2], mark: 66),

        StudentRecord(student: students[2], subject: subjects[1], mark: 90),
        StudentRecord(student: students[2], subject: subjects[3], mark: 80),

        StudentRecord(student: students[3], subject: subjects[2], mark: 55),
        StudentRecord(student: students[3], subject: subjects[3], mark: 43)
    ]
}

struct ContentView: View {
    @State private var records = createSampleRecords()
    @State private var selectedStudentID = "S001"
    @State private var editingRecordID: UUID?
    @State private var markInput = ""
    @State private var message = ""

    var selectedStudent: Student? {
        students.first { $0.id == selectedStudentID }
    }

    func recordsFor(_ student: Student) -> [StudentRecord] {
        records.filter { $0.student.id == student.id }
    }

    func average(for student: Student) -> Double {
        let studentRecords = recordsFor(student)

        let totalCredits = studentRecords.reduce(0) {
            $0 + $1.subject.credits
        }

        guard totalCredits > 0 else { return 0 }

        let weightedTotal = studentRecords.reduce(0.0) {
            $0 + $1.mark * Double($1.subject.credits)
        }

        return weightedTotal / Double(totalCredits)
    }

    func ranking(for student: Student) -> Int {
        let studentAverage = average(for: student)

        return students.filter {
            average(for: $0) > studentAverage
        }.count + 1
    }

    func updateMark() {
        guard let recordID = editingRecordID,
              let newMark = Double(
                markInput.replacingOccurrences(of: ",", with: ".")
              ),
              (0.0...100.0).contains(newMark),
              let record = records.first(where: {
                  $0.id == recordID
              }) else {
            message = "Enter a valid mark from 0 to 100."
            return
        }

        record.mark = newMark

        records = Array(records)
        message = "Mark updated successfully!"
        editingRecordID = nil
        markInput = ""
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Select Student") {
                    Picker("Student", selection: $selectedStudentID) {
                        ForEach(students) { student in
                            Text(student.name).tag(student.id)
                        }
                    }
                }

                if let student = selectedStudent {
                    Section("Student Information") {
                        Text(student.displayInfo())
                        Text("Student ID: \(student.id)")
                    }

                    Section("Academic Results") {
                        HStack {
                            Text("Average Mark")
                            Spacer()
                            Text(String(
                                format: "%.2f",
                                average(for: student)
                            ))
                            .bold()
                        }

                        HStack {
                            Text("Academic Ranking")
                            Spacer()
                            Text("#\(ranking(for: student)) of \(students.count)")
                                .bold()
                        }

                        HStack {
                            Text("Overall Result")
                            Spacer()
                            Text(average(for: student) >= 50
                                 ? "Qualified" : "Not Qualified")
                                .foregroundStyle(
                                    average(for: student) >= 50
                                    ? .green : .red
                                )
                        }
                    }

                    Section("Registered Subjects") {
                        ForEach(recordsFor(student)) { record in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(record.subject.name)
                                    .font(.headline)

                                Text("Credits: \(record.subject.credits)")

                                HStack {
                                    Text(String(
                                        format: "Mark: %.1f",
                                        record.mark
                                    ))

                                    Spacer()

                                    Text(record.isPassed()
                                         ? "Passed" : "Failed")
                                        .foregroundStyle(
                                            record.isPassed()
                                            ? .green : .red
                                        )
                                }

                                Button("Edit Mark") {
                                    editingRecordID = record.id
                                    markInput = String(record.mark)
                                    message = ""
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }

                    if let recordID = editingRecordID,
                       records.contains(where: {
                           $0.id == recordID &&
                           $0.student.id == selectedStudentID
                       }) {
                        Section("Update Mark") {
                            TextField(
                                "New mark (0–100)",
                                text: $markInput
                            )
                            .keyboardType(.decimalPad)

                            Button("Save and Refresh Results") {
                                updateMark()
                            }

                            Button("Cancel", role: .cancel) {
                                editingRecordID = nil
                                markInput = ""
                                message = ""
                            }
                        }
                    }

                    if !message.isEmpty {
                        Section("Message") {
                            Text(message)
                        }
                    }
                }

                Section("Academic Ranking - All Students") {
                    ForEach(
                        students.sorted {
                            average(for: $0) > average(for: $1)
                        }
                    ) { student in
                        HStack {
                            Text("#\(ranking(for: student))")
                                .bold()
                                .frame(width: 35, alignment: .leading)

                            VStack(alignment: .leading) {
                                Text(student.name)
                                Text(student.id)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            Text(String(
                                format: "%.2f",
                                average(for: student)
                            ))
                            .bold()
                        }
                    }
                }
            }
            .navigationTitle("Student Manager")
        }
    }
}

#Preview {
    ContentView()
}
