package com.sb.docker.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class StudentDto {
    private Long studentId;
    private String name;
    private String emailId;
    private AddersDto address;
    private StudyClassDto studyClass;
    private List<ParentDto> parents;
}
