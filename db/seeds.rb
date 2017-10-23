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
      name: "Vitor Barbosa", email: "barbosa@gmail.com", password: "123456789",
      password_confirmation: "123456789", github: "vituuGit"
    },
    {
      name: "Carla", email: "carla@gmail.com", password: "123456789",
      password_confirmation: "123456789", github: "carlaGit"
    }
  ]
)

puts "Creating Projects"
projects = Project.create(
  [
    {
      name: "Owla", description: "This project helps improving classes",
      user_id: User.find_by(name: "Vitor Barbosa").id
    },
    {
      name: "Falko", description: "Agile Projects Manager",
      user_id: User.find_by(name: "Carla").id
    }
  ]
)

puts "Creating Sprints"
releases = Sprint.create(
  [
    {
      name: "Sprint 01", description: "First Sprint", initial_date: "01-08-2016",
      final_date: "01-10-2016", project_id: Project.find_by(name: "Owla").id
    },
    {
      name: "S1", description: "First Sprint", initial_date: "01-10-2016",
      final_date: "01-12-2016", project_id: Project.find_by(name: "Falko").id
    }
  ]
)

puts "Creating Releases"
releases = Release.create(
  [
    {
      name: "R1", description: "RUP Release", initial_date: "01-08-2016",
      final_date: "01-10-2016", project_id: Project.find_by(name: "Owla").id
    },
    {
      name: "R2", description: "Agile Release", initial_date: "01-10-2016",
      final_date: "01-12-2016", project_id: Project.find_by(name: "Owla").id
    },
    {
      name: "R - 01", description: "First Release", initial_date: "01-08-2017",
      final_date: "01-10-2016", project_id: Project.find_by(name: "Falko").id
    }
  ]
)
