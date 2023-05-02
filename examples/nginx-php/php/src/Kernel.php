<?php
namespace Webfux\POC;

class Kernel {
    CONST MESSAGE="Hello World inside";
    /**
     * @return string
     */
    public function verifyClass() : string {
        return __METHOD__;
    }

    public function verifyDB() : string {
        return __METHOD__;
/*
        $dbHost     = getenv("MYSQL_HOST");
        $dbName     = getenv("MYSQL_DATABASE");
        $dbUser     = getenv("MYSQL_USER");
        $dbPwd      = getenv("MYSQL_PASSWORD");
        try {
            $db         = new \PDO("mysql:host=$dbHost;dbname=$dbName", $dbUser, $dbPwd);
            $result     = $db->query("SHOW TABLES");
            while ($row = $result->fetch(\PDO::FETCH_NUM)) {
                $tableList[] = $row[0];
            }
            print_r("Created Tables:");print_r($tableList ?? []);
        } catch (\Throwable $exception) {
            echo $exception->getMessage();
        }
        return self::MESSAGE;
*/
    }
}