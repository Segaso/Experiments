$MySql_Server="10.10.0.46"
$MySql_UID="adsync"
$MySql_Database="meals"
$MySql_pwd="asdfjkl;"

[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
$connectionString = "server=$MySql_Server;uid=$MySql_UID;database=$MySql_Database;pwd='$MySql_pwd'" 

	$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
	$connection.ConnectionString = $connectionString
	$connection.Open()

		$command = $connection.CreateCommand()
		$command.CommandText = "select `First Name` from accounts WHERE username is NULL;"
		$output=$command.ExecuteReader()

			while ($output.Read()) 
			{
				$output.GetString('First Name')
			}


	$connection.Close()