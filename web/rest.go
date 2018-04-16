package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"net/url"
	"os"
	"strconv"
)

type Forecast struct {
	Context    []interface{} `json:"@context"`
	Properties struct {
		Elevation struct {
			UnitCode string  `json:"unitCode"`
			Value    float64 `json:"value"`
		} `json:"elevation"`
		ForecastGenerator string `json:"forecastGenerator"`
		GeneratedAt       string `json:"generatedAt"`
		Periods           []struct {
			DetailedForecast string      `json:"detailedForecast"`
			EndTime          string      `json:"endTime"`
			Icon             string      `json:"icon"`
			IsDaytime        bool        `json:"isDaytime"`
			Name             string      `json:"name"`
			Number           int64       `json:"number"`
			ShortForecast    string      `json:"shortForecast"`
			StartTime        string      `json:"startTime"`
			Temperature      int64       `json:"temperature"`
			TemperatureTrend interface{} `json:"temperatureTrend"`
			TemperatureUnit  string      `json:"temperatureUnit"`
			WindDirection    string      `json:"windDirection"`
			WindSpeed        string      `json:"windSpeed"`
		} `json:"periods"`
		Units      string `json:"units"`
		UpdateTime string `json:"updateTime"`
		Updated    string `json:"updated"`
		ValidTimes string `json:"validTimes"`
	} `json:"properties"`
	Type string `json:"type"`
}

func main() {
	lat := 43.5670
	lon := -116.2405
	endpoint := url.URL{
		Scheme: "https",
		Host:   "api.weather.gov",
		Path:   fmt.Sprintf("/points/%.4f,%.4f/forecast", lat, lon),
	}

	var err error
	if len(os.Args) > 2 {
		lat, err = strconv.ParseFloat(os.Args[1], 64)
		if err != nil {
			log.Fatal(err)
		}
		lon, err = strconv.ParseFloat(os.Args[2], 64)
		if err != nil {
			log.Fatal(err)
		}
	}

	log.Print(endpoint.String())
	req, err := http.NewRequest(http.MethodGet, endpoint.String(), nil)
	if err != nil {
		log.Fatal(err)
	}
	req.Header.Set("Accept", "application/geo+json")
	req.Header.Set("User-Agent", "BSU/RUG")
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()
	buf, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatal(err)
	}
	var fcast Forecast
	err = json.NewDecoder(bytes.NewReader(buf)).Decode(&fcast)
	if err != nil {
		log.Fatal(err)
	}
	for _, p := range fcast.Properties.Periods {
		fmt.Printf("%s: %d°%s\n", p.Name, p.Temperature, p.TemperatureUnit)
	}
}
