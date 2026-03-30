package com.diagram.model;

public class Diagram {
    private int id;
    private int userId;
    private String title;
    private String type;
    private String content;

    public Diagram() {}
    public Diagram(int userId, String title, String type, String content) {
        this.userId = userId;
        this.title = title;
        this.type = type;
        this.content = content;
    }

    public int getId() { return id; }
    public int getUserId() { return userId; }
    public String getTitle() { return title; }
    public String getType() { return type; }
    public String getContent() { return content; }
}