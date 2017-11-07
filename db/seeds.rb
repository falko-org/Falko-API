# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts "Creating Users"
users = User.create(
  [
    {
      name: "Vitor Barbosa",
      email: "barbosa@gmail.com",
      password: "123456789",
      password_confirmation: "123456789",
      github: "vituuGit"
    },
    {
      name: "Carla",
      email: "carla@gmail.com",
      password: "123456789",
      password_confirmation: "123456789",
      github: "carlaGit"
    }
  ]
)

puts "Creating Projects"
projects = [
  Project.find_or_create_by(
    name: "Owla",
    description: "This project helps improving classes",
    user_id: "1",
    check_project: true
  ),
  Project.find_or_create_by(
    name: "Falko",
    description: "Agile Projects Manager",
    user_id: "2",
    check_project: true
  )
]


puts "Creating Releases"
releases = [
  Release.find_or_create_by(
    name: "R1",
    description: "RUP Release",
    initial_date: "01-08-2016",
    final_date: "01-10-2016",
    project_id: "1"
  ),
  Release.find_or_create_by(
    name: "R2",
    description: "Agile Release",
    initial_date: "01-10-2016",
    final_date: "01-12-2016",
    project_id: "1"
  ),
  Release.find_or_create_by(
    name: "R - 01",
    description: "First Release",
    initial_date: "01-08-2016",
    final_date: "01-10-2016",
    project_id: "2"
  ),
  Release.find_or_create_by(
    name: "R - 02",
    description: "Second Release",
    initial_date: "01-10-2016",
    final_date: "01-12-2016",
    project_id: "2"
  )
]

puts "Creating Sprints"
sprints = [
  Sprint.find_or_create_by(
    name: "Sprint 1 - P1",
    description: "First Sprint",
    initial_date: "01-08-2016",
    final_date: "01-10-2016",
    release_id: "1"
  ),
  Sprint.find_or_create_by(
    name: "Sprint 2 - P1",
    description: "Second Sprint",
    initial_date: "01-10-2016",
    final_date: "01-12-2016",
    release_id: "1"
  ),
  Sprint.find_or_create_by(
    name: "Sprint 1 - P2",
    description: "First Sprint",
    initial_date: "01-08-2016",
    final_date: "01-10-2016",
    release_id: "2"
  ),
  Sprint.find_or_create_by(
    name: "Sprint 2 - P2",
    description: "Second Sprint",
    initial_date: "01-10-2016",
    final_date: "01-12-2016",
    release_id: "2"
  )
]

puts "Creating Stories"
stories = [
  Story.find_or_create_by(
    name: "Story 1",
    description: "Story 1 us14",
    assign: "Lucas",
    pipeline: "Backlog",
    initial_date: "01/01/2017",
    final_date: "02/01/2017",
    sprint_id: "1"
  ),
  Story.find_or_create_by(
    name: "Story 2",
    description: "Story 2 us14",
    assign: "Alax",
    pipeline: "Done",
    initial_date: "01/01/2017",
    final_date: "08/01/2017",
    sprint_id: "1"
  ),
  Story.find_or_create_by(
    name: "Story 1",
    description: "Story 1 us14",
    assign: "Matheus B",
    pipeline: "In Progress",
    initial_date: "03/01/2017",
    sprint_id: "2"
  ),
  Story.find_or_create_by(
    name: "Story 2",
    description: "Story 2 us14",
    assign: "Matheus R",
    pipeline: "Backlog",
    initial_date: "01/01/2017",
    sprint_id: "2"
  ),
  Story.find_or_create_by(
    name: "Story 1",
    description: "Story 1 us14",
    assign: "Matheus Roberto",
    pipeline: "In Progress",
    initial_date: "01/01/2017",
    sprint_id: "3"
  ),
  Story.find_or_create_by(
    name: "Story 2",
    description: "Story 2 us14",
    assign: "Thalisson",
    pipeline: "Done",
    initial_date: "07/01/2017",
    final_date: "15/01/2017",
    sprint_id: "3"
  ),
  Story.find_or_create_by(
    name: "Story 1",
    description: "Story 1 us14",
    assign: "Vinícius",
    pipeline: "In Progress",
    initial_date: "01/01/2017",
    sprint_id: "4"
  ),
  Story.find_or_create_by(
    name: "Story 2",
    description: "Story 2 us14",
    assign: "Adrianne",
    pipeline: "In Progress",
    initial_date: "01/01/2017",
    sprint_id: "4"
  )
]

puts "Creating Revisions"
revisions = [
  Revision.find_or_create_by(
    done_report: ["Foi feito a historia us11"],
    undone_report: ["Não foi feito a historia us21"],
    sprint_id: "1"
  ),
  Revision.find_or_create_by(
    done_report: ["Foi feito a historia us12"],
    undone_report: ["Não foi feito a historia us22"],
    sprint_id: "2"
  ),
  Revision.find_or_create_by(
    done_report: ["Foi feito a historia us13"],
    undone_report: ["Não foi feito a historia us23"],
    sprint_id: "3"
  ),
  Revision.find_or_create_by(
    done_report: ["Foi feito a historia us14"],
    undone_report: ["Não foi feito a historia us24"],
    sprint_id: "4"
  )
]
