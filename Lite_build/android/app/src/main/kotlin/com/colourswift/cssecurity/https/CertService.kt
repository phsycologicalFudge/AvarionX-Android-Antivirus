package com.colourswift.cssecurity.https

import android.content.Context
import android.content.Intent
import android.security.KeyChain
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import java.math.BigInteger
import java.security.KeyPairGenerator
import java.security.KeyStore
import java.security.SecureRandom
import java.security.cert.X509Certificate
import java.util.Date
import javax.security.auth.x500.X500Principal
import org.bouncycastle.asn1.x509.BasicConstraints
import org.bouncycastle.asn1.x509.Extension
import org.bouncycastle.asn1.x509.KeyUsage
import org.bouncycastle.cert.jcajce.JcaX509CertificateConverter
import org.bouncycastle.cert.jcajce.JcaX509v3CertificateBuilder
import org.bouncycastle.operator.jcajce.JcaContentSignerBuilder

object CertService {

    private const val KEY_ALIAS = "cs_https_root"
    private const val CERT_NAME = "AVarionX HTTPS Inspection"

    fun ensureCaKeypair() {
        val ks = KeyStore.getInstance("AndroidKeyStore")
        ks.load(null)
        if (ks.containsAlias(KEY_ALIAS)) return

        val generator = KeyPairGenerator.getInstance(
            KeyProperties.KEY_ALGORITHM_RSA,
            "AndroidKeyStore"
        )

        val spec = KeyGenParameterSpec.Builder(
            KEY_ALIAS,
            KeyProperties.PURPOSE_SIGN or KeyProperties.PURPOSE_VERIFY
        )
            .setKeySize(2048)
            .setDigests(KeyProperties.DIGEST_SHA256)
            .setCertificateSubject(X500Principal("CN=$CERT_NAME"))
            .setCertificateSerialNumber(BigInteger.ONE)
            .setCertificateNotBefore(Date())
            .setCertificateNotAfter(Date(System.currentTimeMillis() + 10L * 365 * 24 * 60 * 60 * 1000))
            .build()

        generator.initialize(spec)
        generator.generateKeyPair()
    }

    private fun caEntry(): KeyStore.PrivateKeyEntry {
        val ks = KeyStore.getInstance("AndroidKeyStore")
        ks.load(null)
        return ks.getEntry(KEY_ALIAS, null) as KeyStore.PrivateKeyEntry
    }

    fun buildCaCertificate(): X509Certificate {
        ensureCaKeypair()

        val entry = caEntry()
        val privateKey = entry.privateKey
        val publicKey = entry.certificate.publicKey

        val now = Date()
        val until = Date(System.currentTimeMillis() + 10L * 365 * 24 * 60 * 60 * 1000)
        val serial = BigInteger(64, SecureRandom())

        val issuer = X500Principal("CN=$CERT_NAME")
        val subject = X500Principal("CN=$CERT_NAME")

        val builder = JcaX509v3CertificateBuilder(
            issuer,
            serial,
            now,
            until,
            subject,
            publicKey
        )

        builder.addExtension(Extension.basicConstraints, true, BasicConstraints(true))
        builder.addExtension(
            Extension.keyUsage,
            true,
            KeyUsage(KeyUsage.keyCertSign or KeyUsage.cRLSign)
        )

        val signer = JcaContentSignerBuilder("SHA256withRSA").build(privateKey)
        return JcaX509CertificateConverter().getCertificate(builder.build(signer))
    }

    fun launchInstaller(context: Context) {
        val cert = buildCaCertificate()

        val intent = KeyChain.createInstallIntent().apply {
            putExtra(KeyChain.EXTRA_CERTIFICATE, cert.encoded)
            putExtra(KeyChain.EXTRA_NAME, CERT_NAME)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }

        context.startActivity(intent)
    }
}
