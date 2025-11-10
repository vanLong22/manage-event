// package com.example.demo.service;

// import org.springframework.stereotype.Service;
// import org.springframework.web.multipart.MultipartFile;

// import java.io.IOException;
// import java.nio.file.Files;
// import java.nio.file.Path;
// import java.nio.file.Paths;

// @Service
// public class FileStorageService {

//     private final Path rootLocation = Paths.get("upload-dir");

//     public void store(MultipartFile file, String filename) {
//         try {
//             Files.copy(file.getInputStream(), this.rootLocation.resolve(filename));
//         } catch (IOException e) {
//             throw new RuntimeException("FAIL!");
//         }
//     }

//     public void init() {
//         try {
//             Files.createDirectories(rootLocation);
//         } catch (IOException e) {
//             throw new RuntimeException("Could not initialize storage!");
//         }
//     }
// }
