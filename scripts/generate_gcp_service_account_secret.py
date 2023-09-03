import argparse
import base64


# Example usage:
# python3 generate_gcp_service_account_secret.py /path/to/your-service-account-key.json

def encode_service_account_key(filepath):
    """Encode the content of a given file in base64."""
    with open(filepath, 'rb') as f:
        return base64.b64encode(f.read()).decode('utf-8')


def create_k8s_secret_yaml(encoded_key):
    """Generate a Kubernetes secret YAML with the given encoded key."""
    secret_yaml = f"""
apiVersion: v1
kind: Secret
metadata:
  name: gcp-service-account
type: Opaque
data:
  key.json: {encoded_key}
"""
    return secret_yaml


def main():
    parser = argparse.ArgumentParser(
        description="Generate a Kubernetes secret YAML from a GCP service account key file.")
    parser.add_argument("keyfile", help="Path to the GCP service account key file")

    args = parser.parse_args()

    # Encode the service account key
    encoded_key = encode_service_account_key(args.keyfile)

    # Generate the Kubernetes secret YAML
    secret_yaml = create_k8s_secret_yaml(encoded_key)

    # Print or save the generated YAML
    print(secret_yaml)
    with open('./crds/Secrets/gcp-service-account-secret.yaml', 'w') as f:
        f.write(secret_yaml)


if __name__ == "__main__":
    main()
