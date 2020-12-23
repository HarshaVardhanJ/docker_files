package main

import (
  "net/http"
  "os"
  "log"
  "io"
)

// downloadFile downloads the file from the URL which is given as the first
// argument, and saves the downloaded file under the name given as the second
// argument.
// It returns the name of the downloaded file, or an error if the file
// could not be downloaded.
//
// Input  :  downloadUrl, fileName
// Output :  name of downloaded file, error(if file could not be downloaded)
func downloadFile(downloadUrl string, fileName string) (string, error) {
  // Make GET request
  resp, err := http.Get(downloadUrl)
  // Handle error
  if err != nil {
    return "", err
    log.Fatalln("Could not download file. Error : %v", err)
  }
  // Closing response body
  defer resp.Body.Close()

  // Create file
  downloadedFile, err := os.Create(fileName)
  // Handle error
  if err != nil {
    return "", err
    log.Fatalln("Could not create file %v. Error: %v", fileName, err)
  }
  // Closing the open file
  defer downloadedFile.Close()

  // Download file to created file
  _, err = io.Copy(downloadedFile, resp.Body)
  if err != nil {
    return "", err
    log.Fatalln("Could not copy source to destination. Error : %v", err)
  }

  // Return
  return downloadedFile.Name(), nil
}

func main() {
  downloadUrl := "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
  fileName := "blocked-hosts.txt"

  fileName, err := downloadFile(downloadUrl, fileName)
  if err != nil {
    log.Print("Error : %v", err)
    os.Exit(1)
  }
  log.Println(fileName)
}
