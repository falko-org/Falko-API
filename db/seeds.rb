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
    description: "This project helps agile projects",
    is_project_from_github: true,
    github_slug: nil,
    is_scoring: true,
    user_id: "1"
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
    done_report: ["US01 - Pesquisar Projeto.","US09 - Manter Release Back","US10 - Manter Sprint Back"],
    undone_report: ["US03 - Conectar Conta ao Github","US14 - Manter Historia","US09 - Manter Release Front","US10 - Manter Sprint Front"],
    sprint_id: "3"
  ),
  Revision.find_or_create_by(
    done_report: ["US03 - Conectar Conta ao Github","US09 - Manter Release Front","US10 - Manter Sprint Front"],
    undone_report: ["US14 - Manter Historia","US12 - Manter Retrospectiva"],
    sprint_id: "4"
  ),
  Revision.find_or_create_by(
    done_report: ["US05 - Listar Possíveis Projetos","US04 - Importar Repositório"],
    undone_report: ["US12 - Manter Retrospectiva Front"],
    sprint_id: "5"
  ),
  Revision.find_or_create_by(
    done_report: ["US12 - Manter Retrospectiva Back","US22 - Manter Issue Back","US14 - Manter Historia","US07 - Manter GPA Back"],
    undone_report: ["US12 - Manter Retrospectiva Front","US22 - Manter Issue Front","US07 - Manter GPA Front"],
    sprint_id: "6"
  ),
  Revision.find_or_create_by(
    done_report: ["US11 - Manter Revisão de Sprint","US06 - Designar Membros Back","US15 - Pontuar História Back","US22 - Manter Issue Front"],
    undone_report: ["Tudo foi feito"],
    sprint_id: "7"
  ),
  Revision.find_or_create_by(
    done_report: ["US06 -Designar Membros Front","US08 - Visualizar Burndown","US15 - Pontuar História","US16 - Alocar História para Sprint Back"],
    undone_report: ["US16 - Alocar História para Sprint Front"],
    sprint_id: "8"
  ),
  Revision.find_or_create_by(
    done_report: ["US23 - Planejar Sprint","US19 - Visualizar Velocity"],
    undone_report: ["Histórias Técnicas"],
    sprint_id: "9"
  ),
  Revision.find_or_create_by(
    done_report: ["US20 - Manter EVM Back","US18 - Manter Feature Back"],
    undone_report: ["US20 - Manter EVM Front","US18 - Manter Feature Front"],
    sprint_id: "10"
  ),
  Revision.find_or_create_by(
    done_report: ["US17 - Manter Épico Back","US24 - Gŕafico de Issues"],
    undone_report: ["US20 - Manter EVM", "US21 - Manter Nota", "US17 - Manter Épico"],
    sprint_id: "11"
  ),
]

puts "Creating Retrospective"
retrospectives = [
  Retrospective.find_or_create_by(
    sprint_report: "Sprint 1",
    positive_points: ["Very good"],
    negative_points: ["No tests"],
    improvements: ["Improve front-end"],
    sprint_id: "1"
  ),
  Retrospective.find_or_create_by(
    sprint_report: "Sprint 2",
    positive_points: ["Very good"],
    negative_points: ["No tests"],
    improvements: ["Improve back-end"],
    sprint_id: "2"
  ),
  Retrospective.find_or_create_by(
    sprint_report: "Nesta sprint muitas dívidas foram deixadas. As histórias, em sua maioria, foram apenas parcialmente completas. Isso se deu devido o desnivelamento da equipe em geral. A dependência da equipe de MDS em relação à equipe de GPP e a falta de conhecimento simultâneo dos dois âmbitos da aplicação (back e front-end) acabaram atrasando o desenvolvimento. Além disso, o final de semana foi inutilizado para a produção de código.

A equipe havia decidido que cada história seria completa (back-end e front-end), e não dividida em duas histórias diferentes. Sabíamos que isto geraria um overhead inicial, pois as histórias levariam muito tempo para serem concluídas, como foi possível observar nesta sprint. Entretanto, o grupo ainda acredita que seja a melhor abordagem, pois atua na disseminação do conhecimento da aplicação em sua totalidade.

Para a próxima sprint espera-se que os débitos sejam quitados, com o amadurecimento da equipe. Ademais, uma nova reunião no primeiro dia da sprint (sábado) será estabelecida, e os pareamentos serão alocados de forma a colaborar com estas atividades.

",
    positive_points: ["Time cumpriu com os standups","Pareamentos efetivos"],
    negative_points: ["Desnível do conhecimento entre o time","Dependência do time de MDS com GPP","Alguns pareamentos não aconteceram(problemas com ambiente, internet e hangouts)","Desenvolvimento tardio(fim de semana não foi bem aproveitado para o desenvolvimento)"],
    improvements: ["Formalizar os horários de pareamento","Reunião de desenvolvimento sábado","Treinamento nas tecnologias","Melhorar alocação dos pares","Melhorar atuação do scrum master"],
    sprint_id: "3"
  ),
  Retrospective.find_or_create_by(
    sprint_report: "Nesta sprint também foram deixadas dívidas e o principal motivo foi a falta de conhecimento do grupo com relação a api do github que interferiu até mesmo na ordem de realização das histórias. Outro fator importante foi a ausência de dois membros da equipe que também contribuíram para a não realização de todas as histórias.

Além disso a interdependência entre as histórias mostrou-se um problema, pois impede o avanço da equipe quando há dívidas técnicas, por esse motivo, a história US14 voltou para o backlog, pois há histórias que devem ser realizadas antes dela.

Os super parings realizados contribuíram, pois a equipe realizou mais pareamentos. Do mesmo modo, o feedback das atividades realizadas, coletadas pelo scrum master de forma anônima, possibilitou melhorias específicas a cada membro da equipe.

Por fim, a reunião de sábado se mostrou muito efetiva, uma vez que presencialmente os membros trabalham mais e melhor.

Para a próxima sprint espera-se que os débitos sejam quitados, com o amadurecimento da equipe.",
    positive_points: ["Melhora na comunicação graças aos feedbacks.","Super pairing aumentou a frequência de pareamentos, contribuindo, assim, para a produtividade.","A reunião de sábado mostrou-se efetiva."],
    negative_points: ["Interdependência entre histórias dificultou o desenvolvimento.
(Solução de problemas ficaram em branches específicas, não na devel, onde estariam disponíveis para todo o grupo.)","Membros ausentes (Lucas e Kelvin viajaram)."],
    improvements: ["Ser mais criterioso quanto a política de branches.","Planejar melhor a escolha das histórias pensando na interdependência delas."],
    sprint_id: "4"
  ),
  Retrospective.find_or_create_by(
    sprint_report: "Nesta sprint o número de dívidas técnicas diminuiu principalmente pelo grande esforço que a equipe fez na semana universitária. A equipe estava muito empenhada e todos dedicaram bastante tempo a matéria.

A equipe toda foi dividida em dois nessa sprint e todo o time trabalhou simultaneamente nas mesmas histórias(exceto nas dívidas técnicas), metade no front-end da aplicação, e metade no back-end.

Embora a semana tenha sido muito produtiva nem todos os membros puderam participar dos super parings por motivos de viagem ou outras atividades e a dívida técnica persistiu.",
positive_points: ["Super pairing ajudou a disseminar o conhecimento na equipe","Empenho da equipe"],
negative_points: ["Falta de alguns membros nos pareamentos","Dívida técnica não concluída"],
improvements: ["Maior presença nos pareamentos","Treinamento de Bootstrap"],
    sprint_id: "5"
  ),
  Retrospective.find_or_create_by(
    sprint_report: "Sprint 4",
    positive_points: ["Equipe de MDS mais independente
(Pareamentos MDS vs MDS foram produtivos)","O desenvolvimento das histórias começou mais cedo
(Reunião de desenvolvimento no Sábado cooperou para a finalização das histórias mais cedo)","Divisão de histórias grandes em menores foi positiva","A presença dos membros nos pareamentos melhorou","Dívidas técnicas antigas foram concluídas"],
    negative_points: ["Ausências e atrasos em reuniões
(Stand-up meetings foram negligenciados)
(Membros não avisaram com antecedência as ausências e atrasos nas reuniões)","Critérios de aceitação não documentados atrapalharam o desenvolvimento de algumas histórias.","Algumas histórias dependiam de funcionalidades já implementadas. Problemas com estas funcionalidades prejudicaram o desenvolvimento."],
    improvements: ["Melhorar comunicação
(Avisar com antecedência atrasos e ausências)","Comprometimento com o Stand-up (Presença e Pontualidade)","Sempre documentar critérios de aceitação das histórias da Sprint","Desenvolver uma cultura de “Código Coletivo”","Sempre assinar as issues que estão sendo desenvolvidas
(Nunca assinar uma issue que não estão sendo desenvolvidas naquele momento)","Seguir templates de Pull Request"],
    sprint_id: "6"
  ),
  Retrospective.find_or_create_by(
    sprint_report: "Sprint 5",
    positive_points: ["Boa comunicação nos Pull Requests.","Equipe de MDS mais madura.","A integração entre os PR’s do Github e o Slack melhorou a rastreabilidade.","Melhoria dos critérios de aceitação nas Issues."],
    negative_points: ["Atrasos ainda ocorrem.","Dificuldade de realizar os testes devido à complexidade do código."],
    improvements: ["Atraso não justificado maior que 10 minutos terá que pagar balinha/bombom para cada um do grupo."],
    sprint_id: "7"
  ),
  Retrospective.find_or_create_by(
    sprint_report: "Essa Sprint o grupo de MDS se mostrou mais independente e assumiu algumas responsabilidades sozinhos. As histórias terminaram relativamente rápidas, e isso foi reflexo do empenho da equipe nos pareamentos.

Entretanto, isso também foi em partes um aspecto negativo, pois os membros que terminaram suas histórias não se disponibilizaram para ajudar aqueles que ainda não tinham terminado, e somado a isso alguns membros também não requisitaram ajuda. Logo, houve uma certa falha na comunicação entre pareamentos diferentes, o que levou no atraso de uma história.",
    positive_points: ["Pareamentos efetivos;","MDS mais independente;","Desenvolvimento ágil melhor refletido no burndown;","Leve melhoria com relação aos atrasos;"],
    negative_points: ["Complexidade de realizar testes no código permanecem;","Falta de comunicação entre os pareamentos;
(Pareamentos que finalizaram as histórias no início da sprint não auxiliaram outros alocados em histórias mais complexas, além disso, estes não solicitaram ajuda.)"],
    improvements: ["O Scrum master deve estar mais atento ao que é relatado durante os stand ups;","Utilizar biblioteca Chart.js para substituir a d3.js como forma de testar qual das duas é melhor aplicável ao nosso projeto."],
    sprint_id: "8"
  ),
  Retrospective.find_or_create_by(
    sprint_report: "Sprint 7",
    positive_points: ["Escolha da biblioteca ChartJS facilitou a geração de gráficos;","Equipe organizou documentações que estavam faltando."],
    negative_points: ["Dependência de alguns membros de MDS em relação a outros atrasou desenvolvimento de histórias;","Equipe muito atarefada com outras disciplinas.
(Alguns membros não conseguiram parear de maneira eficiente;)
(Baixo comprometimento com os stand ups do meio ao fim da sprint;)
"],
    improvements: ["Levar em conta o calendário acadêmico dos integrantes da equipe ao planejar a sprint.","Membros devem ser mais independentes para realizar suas histórias"],
    sprint_id: "9"
  ),
  Retrospective.find_or_create_by(
    sprint_report: "Sprint 8",
    positive_points: ["Os testes de aceitação foram feitos."],
    negative_points: ["O fim do semestre dificultou a disponibilidade da equipe.","Testes unitários, faltou proatividade.","Dispersão nas reuniões.","GPA não será utilizado."],
    improvements: ["Apenas um computador ligado nas reuniões de retrospectiva e planejamento.","Arrumar o webhook em produção.","Treinamento de teste unitário.","Fazer o próximo planejamento e revisão da Sprint utilizando o Falko."],
    sprint_id: "10"
  ),
  Retrospective.find_or_create_by(
    sprint_report: "Sprint 9",
    positive_points: ["Gráficos estão saindo com mais facilidade","Pareamentos com grupos menores","Cobertura de teste do front-end aumentou"],
    negative_points: ["Falta de pareamentos","Membros ausentes","Histórias com complexidade muito alta","Dispersão no final do semestre","Falta de comunicação do grupo
(Stand up não foi levado a sério)
"],
    improvements: ["Foco na última sprint","Pareamento presencial todos os dias"],
    sprint_id: "11"
  ),
]
