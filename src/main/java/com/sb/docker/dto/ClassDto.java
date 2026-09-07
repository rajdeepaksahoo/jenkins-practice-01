package com.sb.docker.dto;

import com.sb.docker.enums.ClassName;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class ClassDto {
    private Long classId;
    private ClassName className;
}
