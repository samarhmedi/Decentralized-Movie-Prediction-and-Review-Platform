
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0; 

contract MoviePrediction {
    // custom data structure
    struct Prediction {
        address user; // ethereum address 
        uint256 movieId; // movie id obviously 
        uint256 predictionScore; // user's prediction of the IMDB score
        }

    // This declares a mapping named 'moviePredictions' that associates 
    // movie IDs (uint256) with arrays of Prediction structs.
    mapping(uint256 => Prediction[]) public moviePredictions;

    // This declares a mapping named 'userPredictions' that associates user 
    // addresses (Ethereum addresses) with arrays of uint256 values. 
     event PredictionSubmitted(address indexed user, uint256 indexed movieId, uint256 predictionScore);
    // declares an event named 'PredictionSubmitted' that can be emitted 
    // to log prediction submissions.
     function submitPrediction(uint256 _movieId, uint256 _predictionScore) external {
        // the start of the 'submitPrediction' function definition, which allows users to submit predictions.

        require(_predictionScore >= 0 && _predictionScore <= 10, "Invalid prediction score");
        // checks that the prediction score is within the valid range (0-10). If not, it reverts with an error message.

        Prediction[] storage predictions = moviePredictions[_movieId];
        // retrieves the array of predictions for a specific movie ID and stores it in the 'predictions' variable.

        predictions.push(Prediction(msg.sender, _movieId, _predictionScore));
        //  creates a new Prediction struct with the sender's address, movie ID, and prediction score, and adds it to the 'predictions' array.

        userPredictions[msg.sender].push(_movieId);
        // adds the movie ID to the array of movie predictions for the sender's address.

        emit PredictionSubmitted(msg.sender, _movieId, _predictionScore);
        // emits the 'PredictionSubmitted' event to log the submission of a prediction.
    }

    function getMoviePredictions(uint256 _movieId) external view returns (Prediction[] memory) {
        //the start of the 'getMoviePredictions' function definition, which allows users to retrieve predictions for a specific movie.

        return moviePredictions[_movieId];
        //returns the array of predictions associated with the specified movie ID.
    }

    function getUserPredictions(address _user) external view returns (uint256[] memory) {
        // the start of the 'getUserPredictions' function definition, which allows users to retrieve their prediction history.

        return userPredictions[_user];
        // returns the array of movie IDs associated with predictions made by the specified user.
    }
}