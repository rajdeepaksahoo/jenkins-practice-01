package com.sb.docker.controller;

import com.sb.docker.dto.StudentDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequiredArgsConstructor
public class StudentController {

    private List<StudentDto> students = new ArrayList<>();

    @GetMapping
    public ResponseEntity<List<StudentDto>> getStudents() {
        return ResponseEntity.ok().body(students);
    }

    @PostMapping
    public ResponseEntity<StudentDto> addStudents(@RequestBody StudentDto studentDto) {
        students.add(studentDto);
        return ResponseEntity.ok().body(studentDto);
    }

    @PutMapping
    public ResponseEntity<StudentDto> updateStudents(@RequestBody StudentDto studentDto) {
        students.stream().filter(studentDto1 ->
                studentDto1.getStudentId().equals(studentDto.getStudentId())).findFirst().ifPresent(student -> {
            student.setParents(studentDto.getParents());
            student.setAddress(studentDto.getAddress());
            student.setEmailId(studentDto.getEmailId());
            student.setName(studentDto.getName());

        });
        return ResponseEntity.ok().body(studentDto);
    }

    @DeleteMapping
    public ResponseEntity<StudentDto> deleteStudents(@RequestBody StudentDto studentDto) {
        students.remove(studentDto);
        return ResponseEntity.ok().body(studentDto);
    }
}
