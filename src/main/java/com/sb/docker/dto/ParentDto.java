package com.sb.docker.dto;

import com.sb.docker.enums.ParentType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Data
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class ParentDto {
    private Long parentId;
    private String parentName;
    private ParentType parentType;
}
