# Problem's link: https://www.hackerrank.com/challenges/grading/problem

def gradingStudents(grades)
    roundedGrades = []
    
    grades.each do |grade|
        if grade >= 38 and (grade % 5) >= 3
            grade -= grade % 5
            roundedGrades.push grade + 5
        else
            roundedGrades.push grade
        end
    end
    
    roundedGrades
end
