package com.linkedin.openhouse.cluster.storage.hdfs;

import com.linkedin.openhouse.cluster.storage.BaseStorage;
import com.linkedin.openhouse.cluster.storage.StorageClient;
import com.linkedin.openhouse.cluster.storage.StorageType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Component;

/**
 * The HdfsStorage class is an implementation of the Storage interface for HDFS storage. It uses a
 * HdfsStorageClient to interact with the HDFS file system. The HdfsStorageClient uses the {@link
 * org.apache.hadoop.fs.FileSystem} class to interact with the HDFS file system.
 */
@Component
public class HdfsStorage extends BaseStorage {

  @Autowired @Lazy private HdfsStorageClient hdfsStorageClient;

  /**
   * Get the type of the HDFS storage.
   *
   * @return the type of the HDFS storage
   */
  @Override
  public StorageType.Type getType() {
    return StorageType.HDFS;
  }

  /**
   * Get the HDFS storage client.
   *
   * @return the HDFS storage client
   */
  @Override
  public StorageClient<?> getClient() {
    return hdfsStorageClient;
  }
}
