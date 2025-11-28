package util

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"encoding/hex"
	"fmt"
	"net/url"
)

// DiscourseSSO - Generate Discourse SSO payload and signature
// Based on Discourse SSO protocol: https://meta.discourse.org/t/using-discourse-as-a-sso-provider/32974
func DiscourseSSO(nonce, secret string) (string, error) {
	// Create payload: nonce + return_sso_url
	payload := fmt.Sprintf("nonce=%s&return_sso_url=%s", nonce, url.QueryEscape("http://localhost:3000/discourse/callback"))
	
	// Base64 encode payload
	payloadB64 := base64.StdEncoding.EncodeToString([]byte(payload))
	
	// Create signature: HMAC-SHA256(payload, secret)
	mac := hmac.New(sha256.New, []byte(secret))
	mac.Write([]byte(payloadB64))
	signature := hex.EncodeToString(mac.Sum(nil))
	
	// Return: payload + signature
	return fmt.Sprintf("%s&sig=%s", payloadB64, signature), nil
}

// ValidateDiscourseSSO - Validate incoming Discourse SSO payload
func ValidateDiscourseSSO(payload, signature, secret string) (map[string]string, error) {
	// Verify signature
	mac := hmac.New(sha256.New, []byte(secret))
	mac.Write([]byte(payload))
	expectedSig := hex.EncodeToString(mac.Sum(nil))
	
	if signature != expectedSig {
		return nil, fmt.Errorf("invalid signature")
	}
	
	// Decode payload
	decoded, err := base64.StdEncoding.DecodeString(payload)
	if err != nil {
		return nil, fmt.Errorf("invalid payload encoding")
	}
	
	// Parse query string
	values, err := url.ParseQuery(string(decoded))
	if err != nil {
		return nil, fmt.Errorf("invalid payload format")
	}
	
	result := make(map[string]string)
	for k, v := range values {
		if len(v) > 0 {
			result[k] = v[0]
		}
	}
	
	return result, nil
}

// GenerateDiscourseResponse - Generate response payload for Discourse
func GenerateDiscourseResponse(userData map[string]string, secret string) (string, error) {
	// Add required fields
	userData["nonce"] = userData["nonce"] // Preserve nonce from request
	
	// Build query string
	values := url.Values{}
	for k, v := range userData {
		values.Set(k, v)
	}
	
	// Base64 encode
	payload := base64.StdEncoding.EncodeToString([]byte(values.Encode()))
	
	// Sign
	mac := hmac.New(sha256.New, []byte(secret))
	mac.Write([]byte(payload))
	signature := hex.EncodeToString(mac.Sum(nil))
	
	return fmt.Sprintf("%s&sig=%s", payload, signature), nil
}

// SplitSSOResponse - Split SSO response into payload and signature
func SplitSSOResponse(response string) []string {
	// Response format: "payload&sig=signature"
	parts := make([]string, 2)
	idx := len(response) - 65 // HMAC-SHA256 hex is 64 chars, plus "&sig=" is 5 chars
	if idx > 0 && idx+5 < len(response) && response[idx:idx+5] == "&sig=" {
		parts[0] = response[:idx]
		parts[1] = response[idx+5:]
	} else {
		// Fallback: try to find &sig= anywhere
		for i := len(response) - 70; i >= 0; i-- {
			if i+5 < len(response) && response[i:i+5] == "&sig=" {
				parts[0] = response[:i]
				parts[1] = response[i+5:]
				break
			}
		}
	}
	return parts
}

