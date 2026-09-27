# Pixal3D + TRELLIS.2 + BiRefNet + MoGe
FROM runpod/worker-comfyui:5.10.0-base

# Build-time Hugging Face token
# The token is supplied as a BuildKit secret and is not stored in the image.

# 1. TRELLIS.2 Texture VAE
RUN --mount=type=secret,id=hf_token \
    BACKOFFS="10 20 30 60 90" && \
    for i in 1 2 3 4 5; do \
    HF_TOKEN="$(cat /run/secrets/hf_token 2>/dev/null || true)" \
    comfy model download \
    --url 'https://huggingface.co/Comfy-Org/Pixal3D/resolve/main/vae/trellis_2_texture_vae_bf16.safetensors?download=true' \
    --relative-path models/vae \
    --filename 'trellis_2_texture_vae_bf16.safetensors' && break; \
    if [ $i -eq 5 ]; then echo "Texture VAE download failed" >&2; exit 1; fi; \
    SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i); \
    echo "Retrying in $SLEEP seconds" >&2; sleep $SLEEP; \
    done

# 2. MoGe-2 ViT-L Normal
# LoadMoGeModel expects this model in models/geometry_estimation
RUN --mount=type=secret,id=hf_token \
    BACKOFFS="10 20 30 60 90" && \
    for i in 1 2 3 4 5; do \
    HF_TOKEN="$(cat /run/secrets/hf_token 2>/dev/null || true)" \
    comfy model download \
    --url 'https://huggingface.co/Comfy-Org/MoGe/resolve/main/geometry_estimation/moge_2_vitl_normal_fp16.safetensors?download=true' \
    --relative-path models/geometry_estimation \
    --filename 'moge_2_vitl_normal_fp16.safetensors' && break; \
    if [ $i -eq 5 ]; then echo "MoGe download failed" >&2; exit 1; fi; \
    SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i); \
    echo "Retrying in $SLEEP seconds" >&2; sleep $SLEEP; \
    done

# 3. DINOv3 CLIP Vision
RUN --mount=type=secret,id=hf_token \
    BACKOFFS="10 20 30 60 90" && \
    for i in 1 2 3 4 5; do \
    HF_TOKEN="$(cat /run/secrets/hf_token 2>/dev/null || true)" \
    comfy model download \
    --url 'https://huggingface.co/Comfy-Org/Pixal3D/resolve/main/clip_vision/dino_v3_L_naf_fp32.safetensors?download=true' \
    --relative-path models/clip_vision \
    --filename 'dino_v3_L_naf_fp32.safetensors' && break; \
    if [ $i -eq 5 ]; then echo "DINO download failed" >&2; exit 1; fi; \
    SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i); \
    echo "Retrying in $SLEEP seconds" >&2; sleep $SLEEP; \
    done

# 4. BiRefNet Background Removal
# LoadBackgroundRemovalModel expects this model in models/background_removal
RUN --mount=type=secret,id=hf_token \
    BACKOFFS="10 20 30 60 90" && \
    for i in 1 2 3 4 5; do \
    HF_TOKEN="$(cat /run/secrets/hf_token 2>/dev/null || true)" \
    comfy model download \
    --url 'https://huggingface.co/Comfy-Org/BiRefNet/resolve/main/background_removal/birefnet.safetensors?download=true' \
    --relative-path models/background_removal \
    --filename 'birefnet.safetensors' && break; \
    if [ $i -eq 5 ]; then echo "BiRefNet download failed" >&2; exit 1; fi; \
    SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i); \
    echo "Retrying in $SLEEP seconds" >&2; sleep $SLEEP; \
    done

# 5. Pixal3D BF16
RUN --mount=type=secret,id=hf_token \
    BACKOFFS="10 20 30 60 90" && \
    for i in 1 2 3 4 5; do \
    HF_TOKEN="$(cat /run/secrets/hf_token 2>/dev/null || true)" \
    comfy model download \
    --url 'https://huggingface.co/Comfy-Org/Pixal3D/resolve/main/diffusion_models/pixal3d_bf16.safetensors?download=true' \
    --relative-path models/diffusion_models \
    --filename 'pixal3d_bf16.safetensors' && break; \
    if [ $i -eq 5 ]; then echo "Pixal3D download failed" >&2; exit 1; fi; \
    SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i); \
    echo "Retrying in $SLEEP seconds" >&2; sleep $SLEEP; \
    done

# 6. TRELLIS.2 Shape VAE
# IMPORTANT: This is the SHAPE VAE, not the texture VAE.
RUN --mount=type=secret,id=hf_token \
    BACKOFFS="10 20 30 60 90" && \
    for i in 1 2 3 4 5; do \
    HF_TOKEN="$(cat /run/secrets/hf_token 2>/dev/null || true)" \
    comfy model download \
    --url 'https://huggingface.co/Comfy-Org/Pixal3D/resolve/main/vae/trellis_2_shape_vae_bf16.safetensors?download=true' \
    --relative-path models/vae \
    --filename 'trellis_2_shape_vae_bf16.safetensors' && break; \
    if [ $i -eq 5 ]; then echo "Shape VAE download failed" >&2; exit 1; fi; \
    SLEEP=$(echo $BACKOFFS | cut -d ' ' -f $i); \
    echo "Retrying in $SLEEP seconds" >&2; sleep $SLEEP; \
    done
