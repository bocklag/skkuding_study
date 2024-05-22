resource "aws_cloudfront_origin_access_control" "OAC" {
  name                              = aws_s3_bucket.skkuding-s3.bucket_regional_domain_name
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "cloud-front-tf" {
  origin {
    #domain_name = aws_s3_bucket.skkuding-s3.bucket_regional_domain_name
    domain_name = aws_s3_bucket_website_configuration.static-web-hosting.website_endpoint
    #origin_access_control_id = aws_cloudfront_origin_access_control.OAC.id
    origin_id = "cloud-front-origin-s3"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  origin {
    domain_name = "skkuding-ecs-alb-872150398.ap-northeast-2.elb.amazonaws.com"
    origin_id   = "tf-alb"
  }

  enabled         = true
  is_ipv6_enabled = false

  default_root_object = "index.html"
  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
    #target_origin_id = aws_s3_bucket.skkuding-s3.id
    target_origin_id = "cloud-front-origin-s3"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
  }
  ordered_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    path_pattern           = "/api/*"
    target_origin_id       = "tf-alb"
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

}
#"AWS:SourceArn": ${aws_cloudfront_distribution.cloud-front-tf.arn},
