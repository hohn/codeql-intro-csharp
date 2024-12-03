using System;
using Microsoft.Data.Sqlite;
using System.Diagnostics;
using System.IO;

class Injectable
{
    static string GetUserInput()
    {
        Console.WriteLine("Hello, World!");
        Console.WriteLine("*** Welcome to sql injection ***");
        Console.Write("Please enter name: ");
        string input = Console.ReadLine()?.Trim() ?? string.Empty;
        return input;
    }

    static int GetNewId()
    {
        return Process.GetCurrentProcess().Id;
    }

    static void WriteInfo(int id, string info)
    {
        const string connectionString = "Data Source=users.sqlite";
        using (var connection = new SqliteConnection(connectionString))
        {
            connection.Open();
            // '{info.Replace("'", "''")}')" has no vulnerability
            string query = $"INSERT INTO users VALUES ({id}, '{info}')";
            Console.WriteLine($"Running query: {query}");

            using (var command = new SqliteCommand(query, connection))
            {
                try
                {
                    command.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"Error executing query: {ex.Message}");
                }
            }
        }
    }


    static void Main()
    {
        Console.WriteLine("sqli started");

        string info;
        try
        {
            info = GetUserInput();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"GetUserInput failed: {ex.Message}");
            Environment.Exit(1);
            return; // Unreachable but keeps the compiler happy
        }

        int id = GetNewId();
        WriteInfo(id, info);

        Console.WriteLine("sqli finished");
    }
}
