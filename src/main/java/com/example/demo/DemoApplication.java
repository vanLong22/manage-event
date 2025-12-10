package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.boot.CommandLineRunner;
import org.springframework.beans.factory.annotation.Autowired;
import com.example.demo.service.DataExportService;

@SpringBootApplication
@EnableScheduling
public class DemoApplication {

	public static void main(String[] args) {
		SpringApplication.run(DemoApplication.class, args);
	}
	/*
	@Bean
	CommandLineRunner exportTrain(DataExportService dataExportService) {
		return args -> {
			dataExportService.exportDataToCsv(
				"D:/2022-2026/HOC KI 7/XD HTTT/dataForModel/train.csv"
			);
		};
	}

	@Bean
	CommandLineRunner exportNewEvents(DataExportService dataExportService) {
		return args -> {
			dataExportService.exportNewEventsToCsv(
				"D:/2022-2026/HOC KI 7/XD HTTT/dataForModel/new_events.csv"
			);
		};
	}
	*/
}
