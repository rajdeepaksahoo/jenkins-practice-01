package com.sb.docker.enums;
public enum ClassName {
    CLASS_I(1, "Class I"),
    CLASS_II(2, "Class II"),
    CLASS_III(3, "Class III"),
    CLASS_IV(4, "Class IV"),
    CLASS_V(5, "Class V"),
    CLASS_VI(6, "Class VI"),
    CLASS_VII(7, "Class VII"),
    CLASS_VIII(8, "Class VIII"),
    CLASS_IX(9, "Class IX"),
    CLASS_X(10, "Class X"),
    CLASS_XI(11, "Class XI"),
    CLASS_XII(12, "Class XII");

    private final int level;
    private final String displayName;

    ClassName(int level, String displayName) {
        this.level = level;
        this.displayName = displayName;
    }

    public int getLevel() {
        return level;
    }

    public String getDisplayName() {
        return displayName;
    }

    // A handy method to find an enum by its number (e.g., pass in 5, get CLASS_V)
    public static ClassName fromLevel(int levelNumber) {
        for (ClassName className : ClassName.values()) {
            if (className.getLevel() == levelNumber) {
                return className;
            }
        }
        throw new IllegalArgumentException("Invalid class level: " + levelNumber);
    }
}
