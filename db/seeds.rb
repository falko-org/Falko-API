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
    release_id: "4"
  ),
  Sprint.find_or_create_by(
    name: "Sprint 2 - P2",
    description: "Second Sprint",
    initial_date: "14-10-2017",
    final_date: "20-10-2017",
    release_id: "4"
  ),
  Sprint.find_or_create_by(
    name: "Sprint 3 - P2",
    description: "Third Sprint",
    initial_date: "21-10-2017",
    final_date: "27-10-2017",
    release_id: "4"
  ),
  Sprint.find_or_create_by(
    name: "Sprint 4 - P2",
    description: "Fourth Sprint",
    initial_date: "28-10-2017",
    final_date: "03-11-2017",
    release_id: "4"
  ),
  Sprint.find_or_create_by(
    name: "Sprint 5 - P2",
    description: "Fifth Sprint",
    initial_date: "04-11-2017",
    final_date: "10-11-2017",
    release_id: "4"
  ),
  Sprint.find_or_create_by(
    name: "Sprint 6 - P2",
    description: "Sixth Sprint",
    initial_date: "11-11-2017",
    final_date: "17-11-2017",
    release_id: "4"
  ),
  Sprint.find_or_create_by(
    name: "Sprint 7 - P2",
    description: "Seventh Sprint",
    initial_date: "18-11-2017",
    final_date: "24-11-2017",
    release_id: "4"
  ),
  Sprint.find_or_create_by(
    name: "Sprint 8 - P2",
    description: "Eighth Sprint",
    initial_date: "25-11-2017",
    final_date: "01-12-2017",
    release_id: "4"
  ),
  Sprint.find_or_create_by(
    name: "Sprint 9 - P2",
    description: "Ninth Sprint",
    initial_date: "02-12-2017",
    final_date: "08-12-2017",
    release_id: "4"
  ),
]

puts "Creating Stories"
stories = [
  Story.find_or_create_by(
    name: "Story 1",
    description: "Story 1 us14",
    assign: "Lucas",
    pipeline: "Backlog",
    initial_date: "01-01-2017",
    final_date: "02-01-2017",
    issue_number: "1",
    story_points: "2",
    sprint_id: "1"
  ),
  Story.find_or_create_by(
    name: "Story 2",
    description: "Story 2 us14",
    assign: "Alax",
    pipeline: "Done",
    initial_date: "01-01-2017",
    final_date: "08-01-2017",
    issue_number: "2",
    story_points: "3",
    sprint_id: "1"
  ),
  Story.find_or_create_by(
    name: "Story 1",
    description: "Story 1 us14",
    assign: "Matheus B",
    pipeline: "Done",
    initial_date: "01-01-2017",
    final_date: "04-01-2017",
    issue_number: "3",
    story_points: "5",
    sprint_id: "2"
  ),
  Story.find_or_create_by(
    name: "Story 2",
    description: "Story 2 us14",
    assign: "Matheus R",
    pipeline: "Done",
    initial_date: "01-01-2017",
    final_date: "04-01-2017",
    issue_number: "4",
    story_points: "8",
    sprint_id: "2"
  ),
  Story.find_or_create_by(
    name: "US01",
    description: "Pesquisar Projeto",
    assign: "Alax",
    pipeline: "Done",
    initial_date: "07-10-2017",
    final_date: "12-10-2017",
    story_points: "2",
    issue_number: "5",
    sprint_id: "3"
  ),
  Story.find_or_create_by(
    name: "US03",
    description: "Conectar conta ao Github",
    assign: "Matheus Bernardo",
    pipeline: "Backlog",
    initial_date: "07-10-2017",
    final_date: "13-10-2017",
    story_points: "08",
    issue_number: "6",
    sprint_id: "3"
  ),
  Story.find_or_create_by(
    name: "US09",
    description: "Manter Release",
    assign: "Richard",
    pipeline: "Done",
    initial_date: "07-10-2017",
    final_date: "13-10-2017",
    story_points: "5",
    issue_number: "7",
    sprint_id: "3"
  ),
  Story.find_or_create_by(
    name: "US10",
    description: "Manter Sprints",
    assign: "Thalisson",
    pipeline: "Backlog",
    initial_date: "07-10-2017",
    final_date: "13-10-2017",
    story_points: "5",
    issue_number: "8",
    sprint_id: "3"
  ),
  Story.find_or_create_by(
    name: "US14",
    description: "Manter Historia",
    assign: "Lucas",
    pipeline: "Backlog",
    initial_date: "07-10-2017",
    final_date: "13-10-2017",
    story_points: "5",
    issue_number: "9",
    sprint_id: "3"
  ),
  Story.find_or_create_by(
    name: "US03",
    description: "Conectar conta ao Github",
    assign: "Matheus Bernardo",
    pipeline: "Done",
    initial_date: "14-10-2017",
    final_date: "20-10-2017",
    story_points: "08",
    issue_number: "10",
    sprint_id: "4"
  ),
  Story.find_or_create_by(
    name: "US10",
    description: "Manter Sprints",
    assign: "Thalisson",
    pipeline: "Done",
    initial_date: "14-10-2017",
    final_date: "18-10-2017",
    story_points: "5",
    issue_number: "11",
    sprint_id: "4"
  ),
  Story.find_or_create_by(
    name: "US12",
    description: "Manter Retrospectiva de Sprint",
    assign: "Alax",
    pipeline: "Backlog",
    initial_date: "14-10-2017",
    final_date: "20-10-2017",
    story_points: "5",
    issue_number: "12",
    sprint_id: "4"
  ),
  Story.find_or_create_by(
    name: "US10",
    description: "Manter Historia",
    assign: "Lucas",
    pipeline: "Backlog",
    initial_date: "14-10-2017",
    final_date: "20-10-2017",
    story_points: "5",
    issue_number: "13",
    sprint_id: "4"
  ),
  Story.find_or_create_by(
    name: "US04",
    description: "Importar Repositorio - Back",
    assign: "Todos",
    pipeline: "Done",
    initial_date: "21-10-2017",
    final_date: "26-10-2017",
    story_points: "4",
    issue_number: "14",
    sprint_id: "5"
  ),
  Story.find_or_create_by(
    name: "US04",
    description: "Importar Repositorio - Front",
    assign: "Todos",
    pipeline: "Done",
    initial_date: "21-10-2017",
    final_date: "27-10-2017",
    story_points: "4",
    issue_number: "15",
    sprint_id: "5"
  ),
  Story.find_or_create_by(
    name: "US05",
    description: "Listar Possiveis Projetos",
    assign: "Todos",
    pipeline: "Done",
    initial_date: "21-10-2017",
    final_date: "24-10-2017",
    story_points: "5",
    issue_number: "16",
    sprint_id: "5"
  ),
  Story.find_or_create_by(
    name: "US12",
    description: "Manter Retrospectiva - Front",
    assign: "Richard",
    pipeline: "Done",
    initial_date: "21-10-2017",
    final_date: "24-10-2017",
    story_points: "3",
    issue_number: "17",
    sprint_id: "5"
  ),
  Story.find_or_create_by(
    name: "US12",
    description: "Manter Retrospectiva - Back",
    assign: "Roberto",
    pipeline: "Backlog",
    initial_date: "21-10-2017",
    final_date: "27-10-2017",
    story_points: "2",
    issue_number: "18",
    sprint_id: "5"
  ),
  Story.find_or_create_by(
    name: "US07",
    description: "Visualizar GPA",
    assign: "Pedro",
    pipeline: "Done",
    initial_date: "28-10-2017",
    final_date: "31-10-2017",
    story_points: "5",
    issue_number: "19",
    sprint_id: "6"
  ),
  Story.find_or_create_by(
    name: "US12",
    description: "Manter Retrospectiva - Back",
    assign: "Roberto",
    pipeline: "Done",
    initial_date: "28-10-2017",
    final_date: "01-11-2017",
    story_points: "2",
    issue_number: "20",
    sprint_id: "6"
  ),
  Story.find_or_create_by(
    name: "US14",
    description: "Manter Historia",
    assign: "Vinicius",
    pipeline: "Done",
    initial_date: "28-10-2017",
    final_date: "02-11-2017",
    story_points: "5",
    issue_number: "21",
    sprint_id: "6"
  ),
  Story.find_or_create_by(
    name: "US12",
    description: "Manter Issue - Back",
    assign: "Thalisson",
    pipeline: "Done",
    initial_date: "28-10-2017",
    final_date: "03-11-2017",
    story_points: "4",
    issue_number: "22",
    sprint_id: "6"
  ),
  Story.find_or_create_by(
    name: "US12",
    description: "Manter Issue - Front",
    assign: "Oda",
    pipeline: "Backlog",
    initial_date: "28-10-2017",
    final_date: "03-11-2017",
    story_points: "4",
    issue_number: "23",
    sprint_id: "6"
  ),
  Story.find_or_create_by(
    name: "US22",
    description: "Manter Issue - Front",
    assign: "Oda",
    pipeline: "Done",
    initial_date: "04-11-2017",
    final_date: "06-11-2017",
    story_points: "4",
    issue_number: "24",
    sprint_id: "7"
  ),
  Story.find_or_create_by(
    name: "US11",
    description: "Manter Revisão de Sprint",
    assign: "Oliveira",
    pipeline: "Done",
    initial_date: "04-11-2017",
    final_date: "07-11-2017",
    story_points: "5",
    issue_number: "25",
    sprint_id: "7"
  ),
  Story.find_or_create_by(
    name: "US15",
    description: "Pontuar Historia - Back",
    assign: "Leonardo",
    pipeline: "Done",
    initial_date: "04-11-2017",
    final_date: "10-11-2017",
    story_points: "1",
    issue_number: "26",
    sprint_id: "7"
  ),
  Story.find_or_create_by(
    name: "US06",
    description: "Designar Membros - Back",
    assign: "Adrianne",
    pipeline: "Done",
    initial_date: "04-11-2017",
    final_date: "10-11-2017",
    story_points: "2",
    issue_number: "27",
    sprint_id: "7"
  ),
  Story.find_or_create_by(
    name: "US08",
    description: "Visualizar Burndown",
    assign: "Bernardo",
    pipeline: "Done",
    initial_date: "11-11-2017",
    final_date: "15-11-2017",
    story_points: "5",
    issue_number: "28",
    sprint_id: "8"
  ),
  Story.find_or_create_by(
    name: "US15",
    description: "Pontuar História - Front",
    assign: "Lucas",
    pipeline: "Done",
    initial_date: "11-11-2017",
    final_date: "15-11-2017",
    story_points: "1",
    issue_number: "29",
    sprint_id: "8"
  ),
  Story.find_or_create_by(
    name: "US06",
    description: "Designar Membros - Front",
    assign: "Oda",
    pipeline: "Done",
    initial_date: "11-11-2017",
    final_date: "17-11-2017",
    story_points: "2",
    issue_number: "30",
    sprint_id: "8"
  ),
  Story.find_or_create_by(
    name: "US16",
    description: "Alocar História para Sprint - Back",
    assign: "Alax",
    pipeline: "Done",
    initial_date: "11-11-2017",
    final_date: "13-11-2017",
    story_points: "2",
    issue_number: "31",
    sprint_id: "8"
  ),
  Story.find_or_create_by(
    name: "US16",
    description: "Alocar História para Sprint - Front",
    assign: "Thalisson",
    pipeline: "Backlog",
    initial_date: "11-11-2017",
    final_date: "17-11-2017",
    story_points: "3",
    issue_number: "32",
    sprint_id: "8"
  ),
  Story.find_or_create_by(
    name: "US19",
    description: "Visualizar Velocity",
    assign: "Roberto",
    pipeline: "Done",
    initial_date: "18-11-2017",
    final_date: "24-11-2017",
    story_points: "8",
    issue_number: "33",
    sprint_id: "9"
  ),
  Story.find_or_create_by(
    name: "US23",
    description: "Planejar Sprint - Front",
    assign: "Oda",
    pipeline: "Done",
    initial_date: "18-11-2017",
    final_date: "22-11-2017",
    story_points: "5",
    issue_number: "34",
    sprint_id: "9"
  ),
  Story.find_or_create_by(
    name: "US16",
    description: "Alocar História para Sprint - Front",
    assign: "Bernardo",
    pipeline: "Done",
    initial_date: "18-11-2017",
    final_date: "23-11-2017",
    story_points: "3",
    issue_number: "35",
    sprint_id: "9"
  ),
  Story.find_or_create_by(
    name: "US20",
    description: "Manter EVM - Back",
    assign: "Leo",
    pipeline: "Done",
    initial_date: "25-11-2017",
    final_date: "29-11-2017",
    story_points: "3",
    issue_number: "36",
    sprint_id: "10"
  ),
  Story.find_or_create_by(
    name: "US20",
    description: "Manter EVM - Front",
    assign: "Alax",
    pipeline: "Backlog",
    initial_date: "25-11-2017",
    final_date: "01-12-2017",
    story_points: "3",
    issue_number: "37",
    sprint_id: "10"
  ),
  Story.find_or_create_by(
    name: "US18",
    description: "Manter Feature - Back",
    assign: "Vinicius",
    pipeline: "Backlog",
    initial_date: "25-11-2017",
    final_date: "01-12-2017",
    story_points: "3",
    issue_number: "38",
    sprint_id: "10"
  ),
  Story.find_or_create_by(
    name: "US18",
    description: "Manter Feature - Front",
    assign: "Vinicius",
    pipeline: "Done",
    initial_date: "25-11-2017",
    final_date: "01-12-2017",
    story_points: "2",
    issue_number: "39",
    sprint_id: "10"
  ),
  Story.find_or_create_by(
    name: "US20",
    description: "Manter EVM - Front",
    assign: "Lucas",
    pipeline: "Backlog",
    initial_date: "02-12-2017",
    final_date: "09-12-2017",
    story_points: "4",
    issue_number: "40",
    sprint_id: "11"
  ),
  Story.find_or_create_by(
    name: "US21",
    description: "Manter Nota",
    assign: "Oda",
    pipeline: "Backlog",
    initial_date: "02-12-2017",
    final_date: "09-12-2017",
    story_points: "5",
    issue_number: "41",
    sprint_id: "11"
  ),
  Story.find_or_create_by(
    name: "US17",
    description: "Manter Épico - Back",
    assign: "Thalisson",
    pipeline: "Done",
    initial_date: "02-12-2017",
    final_date: "09-12-2017",
    story_points: "2",
    issue_number: "42",
    sprint_id: "11"
  ),
  Story.find_or_create_by(
    name: "US17",
    description: "Manter Épico - Front",
    assign: "Thalisson",
    pipeline: "Backlog",
    initial_date: "02-12-2017",
    final_date: "09-12-2017",
    story_points: "3",
    issue_number: "43",
    sprint_id: "11"
  ),
  Story.find_or_create_by(
    name: "US24",
    description: "Gráfico de Issues",
    assign: "Roberto",
    pipeline: "Done",
    initial_date: "02-12-2017",
    final_date: "09-12-2017",
    story_points: "2",
    issue_number: "44",
    sprint_id: "11"
  ),
  Story.find_or_create_by(
    name: "US18",
    description: "Manter Feature - Front",
    assign: "Vinicius",
    pipeline: "Backlog",
    initial_date: "02-12-2017",
    final_date: "09-12-2017",
    story_points: "2",
    issue_number: "45",
    sprint_id: "11"
  ),
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
