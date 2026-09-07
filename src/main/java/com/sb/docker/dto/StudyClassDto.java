package com.sb.docker.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class StudyClassDto {
    private Long studyClassId;
    public ClassDto classDto;
}
