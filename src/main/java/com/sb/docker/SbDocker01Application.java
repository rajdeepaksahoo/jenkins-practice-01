package com.sb.docker;

import com.sb.docker.dto.*;
import com.sb.docker.enums.ClassName;
import com.sb.docker.enums.ParentType;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.List;

@SpringBootApplication
public class SbDocker01Application implements CommandLineRunner {

    public static void main(String[] args) {
        SpringApplication.run(SbDocker01Application.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        StudentDto studentDto = new StudentDto();
        studentDto.setStudentId(1L);
        studentDto.setAddress(new AddersDto(1L,"Nelia, Chhatia, Jajpur"));
        studentDto.setName("Rajdeepak");
        studentDto.setEmailId("test@test.com");
        studentDto.setStudyClass(new StudyClassDto(1l,new ClassDto(1l, ClassName.CLASS_I)));
        studentDto.setParents(List.of(
                new ParentDto(1L, "Father",ParentType.Father),
                new ParentDto(2L, "Mother",ParentType.Mother)
        ));
        System.out.println(studentDto);
    }
}
