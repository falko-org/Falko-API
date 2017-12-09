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
    is_project_from_github: true,
    github_slug: nil,
    is_scoring: true,
    user_id: "1"
  ),
  Project.find_or_create_by(
    name: "Falko",
    description: "Agile Projects Manager",
    user_id: "2",
    is_project_from_github: true,
    is_scoring: true
  )
]


puts "Creating Releases"
releases = [
  Release.find_or_create_by(
    name: "R1",
    description: "RUP Release",
    initial_date: "01-01-2016",
    final_date: "01-10-2016",
    project_id: "1"
  ),
  Release.find_or_create_by(
    name: "R2",
    description: "Agile Release",
    initial_date: "01-01-2016",
    final_date: "01-12-2016",
    project_id: "1"
  ),
  Release.find_or_create_by(
    name: "R - 01",
    description: "RUP Release",
    initial_date: "01-08-2016",
    final_date: "01-10-2016",
    project_id: "2"
  ),
  Release.find_or_create_by(
    name: "R - 02",
    description: "Agile Release",
    initial_date: "01-05-2017",
    final_date: "14-12-2017",
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
    initial_date: "01-01-2017",
    final_date: "07-01-2017",
    release_id: "1"
  ),
  Sprint.find_or_create_by(
    name: "Sprint 1 - P2",
    description: "First Sprint",
    initial_date: "07-10-2017",
    final_date: "13-10-2017",
    release_id: "3"
  ),
  Sprint.find_or_create_by(
    name: "Sprint 2 - P2",
    description: "Second Sprint",
    initial_date: "14-10-2017",
    final_date: "20-10-2017",
    release_id: "3"
  ),
  Sprint.find_or_create_by(
    name: "Sprint 3 - P2",
    description: "Third Sprint",
    initial_date: "21-10-2017",
    final_date: "27-10-2017",
    release_id: "3"
  ),
  Sprint.find_or_create_by(
    name: "Sprint 4 - P2",
    description: "Fourth Sprint",
    initial_date: "28-10-2017",
    final_date: "03-11-2017",
    release_id: "3"
  ),
  Sprint.find_or_create_by(
    name: "Sprint 5 - P2",
    description: "Fifth Sprint",
    initial_date: "04-11-2017",
    final_date: "10-11-2017",
    release_id: "3"
  ),
  Sprint.find_or_create_by(
    name: "Sprint 6 - P2",
    description: "Sixth Sprint",
    initial_date: "11-11-2017",
    final_date: "17-11-2017",
    release_id: "3"
  ),
  Sprint.find_or_create_by(
    name: "Sprint 7 - P2",
    description: "Seventh Sprint",
    initial_date: "18-11-2017",
    final_date: "24-11-2017",
    release_id: "3"
  ),
  Sprint.find_or_create_by(
    name: "Sprint 8 - P2",
    description: "Eighth Sprint",
    initial_date: "25-11-2017",
    final_date: "01-12-2017",
    release_id: "3"
  ),
  Sprint.find_or_create_by(
    name: "Sprint 9 - P2",
    description: "Ninth Sprint",
    initial_date: "02-12-2017",
    final_date: "08-12-2017",
    release_id: "3"
  ),
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
    issue_number: "1",
    story_points: "2",
    sprint_id: "1"
  ),
  Story.find_or_create_by(
    name: "Story 2",
    description: "Story 2 us14",
    assign: "Alax",
    pipeline: "Done",
    initial_date: "01/01/2017",
    final_date: "08/01/2017",
    issue_number: "2",
    story_points: "3",
    sprint_id: "1"
  ),
  Story.find_or_create_by(
    name: "Story 1",
    description: "Story 1 us14",
    assign: "Matheus B",
    pipeline: "Done",
    initial_date: "01/01/2017",
    final_date: "04/01/2017",
    issue_number: "3",
    story_points: "5",
    sprint_id: "2"
  ),
  Story.find_or_create_by(
    name: "Story 2",
    description: "Story 2 us14",
    assign: "Matheus R",
    pipeline: "Done",
    initial_date: "01/01/2017",
    final_date: "04/01/2017",
    issue_number: "4",
    story_points: "8",
    sprint_id: "2"
  ),
  Story.find_or_create_by(
    name: "Story 1",
    description: "Story 1 us14",
    assign: "Matheus Roberto",
    pipeline: "In Progress",
    initial_date: "01/01/2017",
    story_points: "10",
    issue_number: "5",
    sprint_id: "3"
  ),
  Story.find_or_create_by(
    name: "Story 2",
    description: "Story 2 us14",
    assign: "Thalisson",
    pipeline: "Done",
    initial_date: "07/01/2017",
    final_date: "15/01/2017",
    story_points: "10",
    issue_number: "6",
    sprint_id: "3"
  ),
  Story.find_or_create_by(
    name: "Story 1",
    description: "Story 1 us14",
    assign: "Vinícius",
    pipeline: "In Progress",
    initial_date: "01/01/2017",
    story_points: "10",
    issue_number: "7",
    sprint_id: "4"
  ),
  Story.find_or_create_by(
    name: "Story 2",
    description: "Story 2 us14",
    assign: "Adrianne",
    pipeline: "Done",
    initial_date: "01/01/2017",
    story_points: "10",
    issue_number: "8",
    sprint_id: "4"
  ),
  Story.find_or_create_by(
    name: "Story 2",
    description: "Story 2 us15",
    assign: "Lucas",
    pipeline: "Done",
    initial_date: "01/01/2017",
    story_points: "15",
    issue_number: "6",
    sprint_id: "3"
  ),
  Story.find_or_create_by(
    name: "Story 2",
    description: "Story 2 us16",
    assign: "Pedro",
    pipeline: "Done",
    initial_date: "01/01/2017",
    story_points: "25",
    issue_number: "6",
    sprint_id: "3"
  )
]

puts "Creating Revisions"
revisions = [
  Revision.find_or_create_by(
    done_report: ["Story US11 was done."],
    undone_report: ["Story US21 was not done."],
    sprint_id: "1"
  ),
  Revision.find_or_create_by(
    done_report: ["Story US12 was done."],
    undone_report: ["Story US22 was not done."],
    sprint_id: "2"
  ),
  Revision.find_or_create_by(
    done_report: ["Story US13 was done."],
    undone_report: ["Story US23 was not done."],
    sprint_id: "3"
  ),
  Revision.find_or_create_by(
    done_report: ["Story US14 was done."],
    undone_report: ["Story US24 was not done."],
    sprint_id: "4"
  )
]

puts "Creating Retrospective"
retrospectives = [
  Retrospective.find_or_create_by(
    sprint_report: "Sprint description",
    positive_points: ["Very good"],
    negative_points: ["No tests"],
    improvements: ["Improve front-end"],
    sprint_id: "1"
  ),
  Retrospective.find_or_create_by(
    sprint_report: "Sprint description",
    positive_points: ["Very good"],
    negative_points: ["No tests"],
    improvements: ["Improve back-end"],
    sprint_id: "2"
  ),
  Retrospective.find_or_create_by(
    sprint_report: "Sprint description",
    positive_points: ["Very good"],
    negative_points: ["No tests"],
    improvements: ["Improve back-end"],
    sprint_id: "3"
  ),
  Retrospective.find_or_create_by(
    sprint_report: "Sprint description",
    positive_points: ["Very good"],
    negative_points: ["No tests"],
    improvements: ["Improve front-end"],
    sprint_id: "4"
  ),
]
