// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MoviePredictionPlatform {
    struct Prediction {
        address user;
        uint256 predictionScore;
        bool hasClaimedReward;
    }

    mapping(uint256 => Prediction[]) public moviePredictions;
    mapping(address => uint256[]) public userPredictions;

    event PredictionSubmitted(address indexed user, uint256 indexed movieId, uint256 predictionScore);
    event RewardClaimed(address indexed user, uint256 indexed movieId, uint256 rewardAmount);

    function submitPrediction(uint256 _movieId, uint256 _predictionScore) external {
        require(_predictionScore >= 0 && _predictionScore <= 10, "Invalid prediction score");

        Prediction[] storage predictions = moviePredictions[_movieId];
        for (uint256 i = 0; i < predictions.length; i++) {
            require(predictions[i].user != msg.sender, "Prediction already submitted");
        }

        predictions.push(Prediction(msg.sender, _predictionScore, false));
        userPredictions[msg.sender].push(_movieId);

        emit PredictionSubmitted(msg.sender, _movieId, _predictionScore);
    }

    function claimReward(uint256 _movieId) external {
        Prediction[] storage predictions = moviePredictions[_movieId];
        uint256 predictionIndex = getUserPredictionIndex(predictions, msg.sender);

        require(predictionIndex != uint256(-1), "No prediction found for the user");
        require(predictions[predictionIndex].hasClaimedReward == false, "Reward already claimed");

        predictions[predictionIndex].hasClaimedReward = true;
        // Distribute tokens as the reward to the user
       // token distribuation in progress

        emit RewardClaimed(msg.sender, _movieId, rewardAmount);
    }

    function getUserPredictionIndex(Prediction[] memory _predictions, address _user) private pure returns (uint256) {
        for (uint256 i = 0; i < _predictions.length; i++) {
            if (_predictions[i].user == _user) {
                return i;
            }
        }
        return uint256(-1);
    }
}
