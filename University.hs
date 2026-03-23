module Main where

import Data.List
import Text.Read (readMaybe)

-- =========================
-- DATA
-- =========================
data Student = Student Int Int Int
    deriving (Show)

students :: [Student]
students =
    [ Student 10567 0 0
    , Student 10450 0 0
    , Student 10974 0 0
    ]

-- =========================
-- MAIN
-- =========================
main :: IO ()
main = menu students

-- =========================
-- MENU
-- =========================
menu :: [Student] -> IO ()
menu list = do
    putStrLn "\n===== SYSTEM ====="
    putStrLn "1. Check In"
    putStrLn "2. Search"
    putStrLn "3. Time Calculation"
    putStrLn "4. List Students"
    putStrLn "5. Check Out"
    putStrLn "6. Exit"
    putStr "Option: "
    op <- getLine

    case op of
        "1" -> do
            newList <- checkIn list
            menu newList

        "2" -> do
            searchStudent list
            menu list

        "3" -> do
            calculateTime list
            menu list

        "4" -> do
            showStudents list
            menu list

        "5" -> do
            newList <- checkOut list
            menu newList

        "6" -> putStrLn "Bye!"

        _ -> do
            putStrLn "Invalid option"
            menu list

-- =========================
-- CHECK IN
-- =========================
checkIn :: [Student] -> IO [Student]
checkIn list = do
    putStr "Enter ID: "
    idStr <- getLine

    case readMaybe idStr of
        Nothing -> do
            putStrLn "Invalid ID"
            return list

        Just sid ->
            if not (exists sid list) then do
                putStrLn "ID not found"
                return list
            else do
                putStr "Entry time: "
                tStr <- getLine

                case readMaybe tStr of
                    Nothing -> do
                        putStrLn "Invalid time"
                        return list

                    Just t -> do
                        let newList = map (updateEntry sid t) list
                        putStrLn "Check-in successful"
                        return newList

-- =========================
-- CHECK OUT
-- =========================
checkOut :: [Student] -> IO [Student]
checkOut list = do
    putStr "Enter ID: "
    idStr <- getLine

    case readMaybe idStr of
        Nothing -> do
            putStrLn "Invalid ID"
            return list

        Just sid ->
            if not (exists sid list) then do
                putStrLn "ID not found"
                return list
            else do
                putStr "Exit time: "
                tStr <- getLine

                case readMaybe tStr of
                    Nothing -> do
                        putStrLn "Invalid time"
                        return list

                    Just t -> do
                        let newList = map (updateExit sid t) list
                        putStrLn "Check-out successful"
                        return newList

-- =========================
-- SEARCH
-- =========================
searchStudent :: [Student] -> IO ()
searchStudent list = do
    putStr "Enter ID: "
    idStr <- getLine

    case readMaybe idStr of
        Nothing -> putStrLn "Invalid ID"

        Just sid ->
            case find (matchID sid) list of
                Nothing -> putStrLn "Student not found"
                Just s  -> printStudent s

-- =========================
-- TIME
-- =========================
calculateTime :: [Student] -> IO ()
calculateTime list = do
    putStr "Enter ID: "
    idStr <- getLine

    case readMaybe idStr of
        Nothing -> putStrLn "Invalid ID"

        Just sid ->
            case find (matchID sid) list of
                Nothing -> putStrLn "Not found"

                Just (Student _ entry exit)
                    | entry == 0 -> putStrLn "No entry registered"
                    | exit == 0  -> putStrLn "No exit registered"
                    | otherwise  ->
                        putStrLn ("Time: " ++ show (exit - entry) ++ " minutes")

-- =========================
-- LIST
-- =========================
showStudents :: [Student] -> IO ()
showStudents list = do
    putStrLn "\n--- STUDENTS ---"
    mapM_ printStudent list

-- =========================
-- PRINT BONITO
-- =========================
printStudent :: Student -> IO ()
printStudent (Student id entry exit) = do
    putStrLn ("ID: " ++ show id)
    putStrLn ("Entry: " ++ showTime entry)
    putStrLn ("Exit: " ++ showTime exit)
    putStrLn "----------------"

showTime :: Int -> String
showTime 0 = "Not registered"
showTime t = show t

-- =========================
-- HELPERS
-- =========================
matchID :: Int -> Student -> Bool
matchID sid (Student id _ _) = id == sid

exists :: Int -> [Student] -> Bool
exists sid list = any (matchID sid) list

updateEntry :: Int -> Int -> Student -> Student
updateEntry sid t (Student id entry exit)
    | id == sid = Student id t exit
    | otherwise = Student id entry exit

updateExit :: Int -> Int -> Student -> Student
updateExit sid t (Student id entry exit)
    | id == sid = Student id entry t
    | otherwise = Student id entry exit